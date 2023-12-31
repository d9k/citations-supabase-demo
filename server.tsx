import { serve } from 'https://deno.land/std@0.176.0/http/server.ts';
import { type Context, createServer } from 'ultra/server.ts';
import App from '/~/app/app.tsx';
import { getCookie as honoGetCookie } from 'hono/cookie';
// import { createServerClient } from '@supabase/ssr';

// React Router
import { StaticRouter } from 'react-router-dom/server';

// React Helmet Async
import { HelmetProvider } from 'react-helmet-async';
import useServerInsertedHTML from 'ultra/hooks/use-server-inserted-html.js';

// React Query
import { QueryClientProvider } from '@tanstack/react-query';
import { useDehydrateReactQuery } from '/~/app/react-query/useDehydrateReactQuery.tsx';
import { queryClient } from '/~/app/react-query/query-client.ts';

import * as dotenv from 'dotenv';

import {
  felaRenderer,
  FelaRendererProviderConstructor,
} from '/~/app/providers-constructors/fela.tsx';
import { createHeadInsertionTransformStream } from 'ultra/stream.ts';

import { renderToMarkup } from 'fela-dom';
// import { SupabaseServerProviderConstructor } from './src/app/providers-constructors/supabase-server.tsx.bk';
import {
  COOKIE_NAME_SUPABASE_ACCESS_TOKEN,
  COOKIE_NAME_SUPABASE_REFRESH_TOKEN,
} from '/~/shared/api/supabase/const.ts';

import {
  SsrSupabaseConstructor,
} from '/~/app/providers-constructors/supabase-ssr.tsx';
import { Suspense } from 'react';
import { Spinner } from '/~/shared/ui/spinner.tsx';
import { randomRange } from '/~/shared/lib/math/random.ts';
import AppHtmlWrapper from '/~/app/app-html-wrapper.tsx';
import { QueryParamProvider } from 'use-query-params';
import RouteAdapter from '/~/shared/lib/react/routing/RouteAdapter.tsx';
import { ReactRouter6Adapter } from 'use-query-params/adapters/react-router-6';
import { makeMockQueryParamAdapter } from '/~/shared/lib/react/routing/makeMockQueryParamAdapter.tsx';

import { AppWrapper } from './src/app/app-wrapper.tsx';

const { load: loadDotEnv } = dotenv;

const env = await loadDotEnv();
const { ULTRA_PUBLIC_SUPABASE_URL, ULTRA_PUBLIC_SUPABASE_ANON_KEY } = env;

console.log(ULTRA_PUBLIC_SUPABASE_URL, ULTRA_PUBLIC_SUPABASE_ANON_KEY);

const server = await createServer({
  importMapPath: import.meta.resolve('./importMap.json'),
  browserEntrypoint: import.meta.resolve('./client.tsx'),
});

// deno-lint-ignore no-explicit-any
const helmetContext: Record<string, any> = {};

type ServerAppProps = {
  context: Context;
  // supabaseClient: SupabaseCreateClientResult;
  // supabaseUser: User | null;
};

function ServerApp(
  { context /*, supabaseClient, supabaseUser*/ }: ServerAppProps,
) {
  useServerInsertedHTML(() => {
    const { helmet } = helmetContext;
    return (
      <>
        {helmet.title.toComponent()}
        {helmet.priority.toComponent()}
        {helmet.meta.toComponent()}
        {helmet.link.toComponent()}
        {helmet.script.toComponent()}
      </>
    );
  });

  useDehydrateReactQuery(queryClient);

  const requestUrl = new URL(context.req.url);

  console.log('__TEST__', { location, requestUrl });

  const cookies = honoGetCookie(context);
  console.log('__TEST__ cookies:', JSON.stringify(cookies));

  const getCookie = (cookieName: string) => honoGetCookie(context, cookieName);

  const supabaseAccessToken = getCookie(COOKIE_NAME_SUPABASE_ACCESS_TOKEN);
  const supabaseRefreshToken = getCookie(COOKIE_NAME_SUPABASE_REFRESH_TOKEN);

  const SsrMockAdapter = makeMockQueryParamAdapter(requestUrl);

  return (
    <AppHtmlWrapper>
      {
        /* <SupabaseProvider value={supabaseClient}>
                <SupabaseUserProvider value={supabaseUser}> */
      }
      <div id='app'>
        <HelmetProvider context={helmetContext}>
          <QueryClientProvider client={queryClient}>
            <FelaRendererProviderConstructor>
              <AppWrapper>
                <Suspense fallback={<Spinner />}>
                  <SsrSupabaseConstructor
                    anonKey={ULTRA_PUBLIC_SUPABASE_ANON_KEY}
                    getCookie={getCookie}
                    supabaseUrl={ULTRA_PUBLIC_SUPABASE_URL}
                    queryKeyUniqueSuffix={`${+new Date()}_${
                      randomRange(0, 100000)
                    }`}
                    supabaseAccessToken={supabaseAccessToken}
                    supabaseRefreshToken={supabaseRefreshToken}
                  >
                    <StaticRouter location={new URL(context.req.url).pathname}>
                      <QueryParamProvider
                        // @ts-ignore The expected type comes from property 'adapter' which is declared here on type 'IntrinsicAttributes & QueryParamProviderProps'
                        // adapter={RouteAdapter}
                        // adapter={ReactRouter6Adapter}
                        adapter={SsrMockAdapter}
                        // location={requestUrl}
                      >
                        <App />
                      </QueryParamProvider>
                    </StaticRouter>
                  </SsrSupabaseConstructor>
                </Suspense>
              </AppWrapper>
            </FelaRendererProviderConstructor>
          </QueryClientProvider>
        </HelmetProvider>
      </div>
      {/* /app */}
      {
        /* </SupabaseUserProvider>
              </SupabaseProvider> */
      }
    </AppHtmlWrapper>
  );
}

server.get('*', async (context) => {
  // clear query cache
  queryClient.clear();

  await new Promise((resolve) => setTimeout(resolve, 300));

  // const {
  //   supabaseClient,
  //   supabaseUser,
  // } = await ssrSupabaseConstructorHelper({
  //   anonKey: ULTRA_PUBLIC_SUPABASE_ANON_KEY,
  //   getCookie,
  //   supabaseUrl: ULTRA_PUBLIC_SUPABASE_URL,
  //   supabaseAccessToken,
  //   supabaseRefreshToken,
  // });

  /**
   * Render the request
   */
  const result = await server.render(
    <ServerApp
      context={context}
      // supabaseClient={supabaseClient}
      // supabaseUser={supabaseUser}
    />,
  );

  // let felaStylesInjectFirstTime = true;

  const felaStylesInject = createHeadInsertionTransformStream(() => {
    // if (!felaStylesInjectFirstTime) {
    //   return Promise.resolve('<style></style>');
    // }
    // felaStylesInjectFirstTime = false;

    // console.log("felaStylesInject: start");

    // const felaStylesMarkup = felaRenderer.renderToMarkup();
    const felaStylesMarkup = renderToMarkup(felaRenderer);

    // console.log("felaStylesInject: felaStylesMarkup:", felaStylesMarkup);

    return Promise.resolve(felaStylesMarkup || '');
    // return Promise.resolve('__TEST_1__');
  });

  const resultWithFelaStyles = result.pipeThrough(felaStylesInject);

  return context.body(resultWithFelaStyles, 200, {
    // return context.body(result, 200, {
    'content-type': 'text/html; charset=utf-8',
  });
});
if (import.meta.main) {
  serve(server.fetch);
}

if (server.importMap) {
  server.importMap.imports['/~/'] = '/_ultra/compiler/src/';
}

// console.log(server.importMap);

export default server;
