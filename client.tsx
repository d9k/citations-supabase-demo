import hydrate from 'ultra/hydrate.js';
import App from '/~/app/app.tsx';
import { SupabaseBrowserProviderConstructor } from '/~/app/providers-constructors/supabase-browser.tsx';
import useEnv from 'ultra/hooks/use-env.js';

// React Router
import { BrowserRouter } from 'react-router-dom';

import { HelmetProvider } from 'react-helmet-async';

import { QueryParamProvider } from 'use-query-params';
// import { ReactRouter6Adapter } from 'use-query-params/adapters/react-router-6';

// React Query
import { Hydrate, QueryClientProvider } from '@tanstack/react-query';
import { queryClient } from '/~/app/react-query/query-client.ts';
import { FelaRendererProviderConstructor } from '/~/app/providers-constructors/fela.tsx';
import { Suspense } from 'react';
import { Spinner } from '/~/shared/ui/spinner.tsx';
import { SsrSupabaseConstructor } from '/~/app/providers-constructors/supabase-ssr.tsx';
import { randomRange } from '/~/shared/lib/math/random.ts';
// import AppHtmlWrapper from '/~/app/app-html-wrapper.tsx';
import { AppWrapper } from './src/app/app-wrapper.tsx';
import { SupabaseBrowserAuthManager } from '/~/app/providers-constructors/browser-auth-manager.tsx';
import RouteAdapter from '/~/shared/lib/react/routing/RouteAdapter.tsx';
declare const __REACT_QUERY_DEHYDRATED_STATE: unknown;
// import { BodyTemplate } from './src/widgets/templates/BodyTemplate.tsx.bk';

function ClientApp() {
  return (
    <HelmetProvider>
      <QueryClientProvider client={queryClient}>
        <FelaRendererProviderConstructor>
          <Hydrate state={__REACT_QUERY_DEHYDRATED_STATE}>
            {/* @ts-ignore 'Router' cannot be used as a JSX component. */}
            <AppWrapper>
              <Suspense fallback={<Spinner />}>
                <SupabaseBrowserProviderConstructor
                  anonKey={useEnv('ULTRA_PUBLIC_SUPABASE_ANON_KEY')!}
                  supabaseUrl={useEnv('ULTRA_PUBLIC_SUPABASE_URL')!}
                >
                  <SupabaseBrowserAuthManager
                    queryKeyUniqueSuffix={`${+new Date()}_${
                      randomRange(0, 100000)
                    }`}
                  >
                    {
                      /* <SsrSupabaseConstructor
                      anonKey={''}
                      getCookie={(a) => ''}
                      supabaseUrl={''}
                      queryKeyUniqueSuffix={`${+new Date()}_${
                        randomRange(0, 100000)
                      }`}
                      supabaseAccessToken={''}
                      supabaseRefreshToken={''}
                    > */
                    }
                    <BrowserRouter>
                      <QueryParamProvider
                        // @ts-ignore The expected type comes from property 'adapter' which is declared here on type 'IntrinsicAttributes & QueryParamProviderProps'
                        adapter={RouteAdapter}
                        // adapter={ReactRouter6Adapter}
                      >
                        <App />
                      </QueryParamProvider>
                    </BrowserRouter>
                  </SupabaseBrowserAuthManager>
                </SupabaseBrowserProviderConstructor>
              </Suspense>
            </AppWrapper>
            {/* </SsrSupabaseConstructor> */}
          </Hydrate>
        </FelaRendererProviderConstructor>
      </QueryClientProvider>
    </HelmetProvider>
  );
}

const appElement = document.getElementById('app');

if (!appElement) {
  throw Error('app element not found');
}

hydrate(appElement, <ClientApp />);
