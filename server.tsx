import { serve } from 'https://deno.land/std@0.176.0/http/server.ts';
import { type Context, createServer } from 'ultra/server.ts';
import App from '/~/app/app.tsx';
import { getCookie as honoGetCookie } from 'hono/cookie';
// import { createServerClient } from '@supabase/ssr';
import { createClient } from '@supabase/supabase-js';
import { Database } from '/~/shared/api/supabase/types.generated.ts';

// React Router
import { StaticRouter } from 'react-router-dom/server';

// React Helmet Async
import { HelmetProvider } from 'react-helmet-async';
import useServerInsertedHTML from 'ultra/hooks/use-server-inserted-html.js';

// React Query
import { QueryClientProvider } from '@tanstack/react-query';
import { useDehydrateReactQuery } from '/~/app/react-query/useDehydrateReactQuery.tsx';
import { queryClient } from '/~/app/react-query/query-client.ts';

import {
  SupabaseCreateClientResult,
  SupabaseProvider,
} from '/~/shared/providers/supabase/client.ts';

import * as dotenv from 'dotenv';

import {
  felaRenderer,
  FelaRendererProviderConstructor,
} from '/~/app/providers-constructors/fela.tsx';
import { createHeadInsertionTransformStream } from 'ultra/stream.ts';

import { renderToMarkup } from 'fela-dom';
// import { SupabaseServerProviderConstructor } from './src/app/providers-constructors/supabase-server.tsx.bk';
import { useCallback } from 'react';
import {
  COOKIE_NAME_SUPABASE_ACCESS_TOKEN,
  COOKIE_NAME_SUPABASE_REFRESH_TOKEN,
} from '/~/shared/api/supabase/const.ts';

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
  supabase: SupabaseCreateClientResult;
};

function ServerApp({ context }: ServerAppProps) {
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

  // context.req.cookie('example-cookie');
  const cookies = honoGetCookie(context);
  console.log('__TEST__ cookies:', JSON.stringify(cookies));
  // console.log(
  //   '__TEST__ example-coookie:',
  //   honoGetCookie(context, 'example-cookie'),
  // );

  // const getCookie = useCallback(
  //   (cookieName: string) => honoGetCookie(context, cookieName),
  //   [context],
  // );

  return (
    <HelmetProvider context={helmetContext}>
      <QueryClientProvider client={queryClient}>
        <FelaRendererProviderConstructor>
          <StaticRouter location={new URL(context.req.url).pathname}>
            {
              /* <SupabaseServerProviderConstructor
              anonKey={ULTRA_PUBLIC_SUPABASE_ANON_KEY}
              supabaseUrl={ULTRA_PUBLIC_SUPABASE_URL}
              getCookie={getCookie}
            > */
            }
            <App />
            {/* </SupabaseServerProviderConstructor> */}
          </StaticRouter>
        </FelaRendererProviderConstructor>
      </QueryClientProvider>
    </HelmetProvider>
  );
}

server.get('*', async (context) => {
  // clear query cache
  queryClient.clear();

  const getCookie = (cookieName: string) => honoGetCookie(context, cookieName);

  // const supabaseClient = createServerClient<Database>(
  // const supabaseClient = createServerClient<Database>(
  const supabaseClient = createClient<Database>(
    ULTRA_PUBLIC_SUPABASE_URL,
    ULTRA_PUBLIC_SUPABASE_ANON_KEY,
    // {
    //   auth: {
    //     flowType: 'implicit',
    //   },
    //   cookies: {
    //     get: getCookie,
    //   },
    // },
  );

  const supabaseAccessToken = getCookie(COOKIE_NAME_SUPABASE_ACCESS_TOKEN);
  const supabaseRefreshToken = getCookie(COOKIE_NAME_SUPABASE_REFRESH_TOKEN);

  /** @see https://supabase.com/docs/guides/auth/server-side-rendering#bringing-it-together */
  // const supabaseSession = await supabaseClient.auth.getSession();

  if (supabaseAccessToken && supabaseRefreshToken) {
    const supabaseSession = await supabaseClient.auth.setSession({
      refresh_token: supabaseRefreshToken,
      access_token: supabaseAccessToken,
      // {
      //   auth: { persistSession: false },
      // }
    });

    console.log('__TEST__: server: supabaseSession:', supabaseSession);

    const supabaseUser = await supabaseClient.auth.getUser();

    console.log('__TEST__: server: supabaseUser:', supabaseUser);
  }

  /**
   * Render the request
   */
  const result = await server.render(
    <ServerApp context={context} supabase={supabaseClient} />,
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
