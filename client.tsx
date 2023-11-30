import hydrate from 'ultra/hydrate.js';
import App from '/~/app/app.tsx';

// React Router
import { BrowserRouter } from 'react-router-dom';

import { HelmetProvider } from 'react-helmet-async';

// React Query
import { Hydrate, QueryClientProvider } from '@tanstack/react-query';
import { queryClient } from '/~/app/react-query/query-client.ts';
import { FelaRendererProviderConstructor } from '/~/app/providers-constructors/fela.tsx';
declare const __REACT_QUERY_DEHYDRATED_STATE: unknown;

function ClientApp() {
  return (
    <HelmetProvider>
      <QueryClientProvider client={queryClient}>
        <FelaRendererProviderConstructor>
          <Hydrate state={__REACT_QUERY_DEHYDRATED_STATE}>
            {/* @ts-ignore 'Router' cannot be used as a JSX component. */}
            <BrowserRouter>
              <App />
            </BrowserRouter>
          </Hydrate>
        </FelaRendererProviderConstructor>
      </QueryClientProvider>
    </HelmetProvider>
  );
}

hydrate(document, <ClientApp />);
