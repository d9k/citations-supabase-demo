import { serve } from "https://deno.land/std@0.176.0/http/server.ts";
import { type Context, createServer } from "ultra/server.ts";
import App from "./src/app.tsx";

// Wouter
import { Router } from "wouter";
import staticLocationHook from "wouter/static-location";
import { SearchParamsProvider } from "/wouter/index.tsx";

// React Helmet Async
import { HelmetProvider } from "react-helmet-async";
import useServerInsertedHTML from "ultra/hooks/use-server-inserted-html.js";

// React Query
import { QueryClientProvider } from "@tanstack/react-query";
import { useDehydrateReactQuery } from "./src/react-query/useDehydrateReactQuery.tsx";
import { queryClient } from "./src/react-query/query-client.ts";

import * as dotenv from "dotenv";

const { load: loadDotEnv } = dotenv;

const env = await loadDotEnv();
const { SUPABASE_URL, SUPABASE_ANON_KEY } = env;

console.log(SUPABASE_URL, SUPABASE_ANON_KEY);

const server = await createServer({
  importMapPath: import.meta.resolve("./importMap.json"),
  browserEntrypoint: import.meta.resolve("./client.tsx"),
});

// deno-lint-ignore no-explicit-any
const helmetContext: Record<string, any> = {};

function ServerApp({ context }: { context: Context }) {
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

  return (
    <HelmetProvider context={helmetContext}>
      <QueryClientProvider client={queryClient}>
        <Router hook={staticLocationHook(requestUrl.pathname)}>
          <SearchParamsProvider value={requestUrl.searchParams}>
            <App />
          </SearchParamsProvider>
        </Router>
      </QueryClientProvider>
    </HelmetProvider>
  );
}

server.get("*", async (context) => {
  // clear query cache
  queryClient.clear();

  /**
   * Render the request
   */
  const result = await server.render(<ServerApp context={context} />);

  return context.body(result, 200, {
    "content-type": "text/html; charset=utf-8",
  });
});
if (import.meta.main) {
  serve(server.fetch);
}
export default server;
