import hydrate from 'ultra/hydrate.js';
import App from '/~/app/app.tsx';
import { SupabaseBrowserProviderConstructor } from '/~/app/providers-constructors/supabase-browser.tsx';
import useEnv from 'ultra/hooks/use-env.js';

// React Router
import { BrowserRouter } from 'react-router-dom';

import { HelmetProvider } from 'react-helmet-async';

// React Query
import { Hydrate, QueryClientProvider } from '@tanstack/react-query';
import { queryClient } from '/~/app/react-query/query-client.ts';
import { FelaRendererProviderConstructor } from '/~/app/providers-constructors/fela.tsx';
import { Suspense } from 'react';
import { Spinner } from '/~/shared/ui/spinner.tsx';
import { SsrSupabaseConstructor } from '/~/app/providers-constructors/supabase-ssr.tsx';
import { randomRange } from '/~/shared/lib/math/random.ts';
import AppHtmlWrapper from '/~/app/app-html-wrapper.tsx';
declare const __REACT_QUERY_DEHYDRATED_STATE: unknown;

function ClientApp() {
  return (
    <HelmetProvider>
      <QueryClientProvider client={queryClient}>
        <FelaRendererProviderConstructor>
          <Hydrate state={__REACT_QUERY_DEHYDRATED_STATE}>
            {/* @ts-ignore 'Router' cannot be used as a JSX component. */}
            <AppHtmlWrapper>
              <Suspense fallback={<Spinner />}>
                <SupabaseBrowserProviderConstructor
                  anonKey={useEnv('ULTRA_PUBLIC_SUPABASE_ANON_KEY')!}
                  supabaseUrl={useEnv('ULTRA_PUBLIC_SUPABASE_URL')!}
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
                    <App />
                  </BrowserRouter>
                </SupabaseBrowserProviderConstructor>
              </Suspense>
            </AppHtmlWrapper>
            {/* </SsrSupabaseConstructor> */}
          </Hydrate>
        </FelaRendererProviderConstructor>
      </QueryClientProvider>
    </HelmetProvider>
  );
}

hydrate(document, <ClientApp />);
