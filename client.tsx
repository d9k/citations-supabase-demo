import hydrate from "ultra/hydrate.js";
import App from "./src/app.tsx";

// Wouter
import { Router } from "wouter";
import { SearchParamsProvider } from "./src/wouter/index.tsx";

import { HelmetProvider } from "react-helmet-async";

// React Query
import { Hydrate, QueryClientProvider } from "@tanstack/react-query";
import { queryClient } from "./src/react-query/query-client.ts";
declare const __REACT_QUERY_DEHYDRATED_STATE: unknown;

function ClientApp() {
  return (
    <HelmetProvider>
      <QueryClientProvider client={queryClient}>
        <Hydrate state={__REACT_QUERY_DEHYDRATED_STATE}>
          <Router>
            <SearchParamsProvider
              value={new URLSearchParams(window.location.search)}
            >
              <App />
            </SearchParamsProvider>
          </Router>
        </Hydrate>
      </QueryClientProvider>
    </HelmetProvider>
  );
}

hydrate(document, <ClientApp />);
