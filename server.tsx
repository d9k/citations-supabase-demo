import { serve } from "https://deno.land/std@0.176.0/http/server.ts";
import { type Context, createServer } from "ultra/server.ts";
import App from "/~/app/app.tsx";

// React Router
import { StaticRouter } from "react-router-dom/server";

// React Helmet Async
import { HelmetProvider } from "react-helmet-async";
import useServerInsertedHTML from "ultra/hooks/use-server-inserted-html.js";

// React Query
import { QueryClientProvider } from "@tanstack/react-query";
import { useDehydrateReactQuery } from "/~/app/react-query/useDehydrateReactQuery.tsx";
import { queryClient } from "/~/app/react-query/query-client.ts";

import * as dotenv from "dotenv";
import {
  felaRenderer,
  FelaRendererProvider,
} from "/~/app/providers/individually/fela.tsx";
import { createHeadInsertionTransformStream } from "ultra/stream.ts";

import { renderToMarkup } from "fela-dom";

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
        <StaticRouter location={new URL(context.req.url).pathname}>
          <FelaRendererProvider>
            <App />
          </FelaRendererProvider>
        </StaticRouter>
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

  let felaStylesInjectFirstTime = true;

  const felaStylesInject = createHeadInsertionTransformStream(() => {
    if (!felaStylesInjectFirstTime) {
      return Promise.resolve('');
    }
    felaStylesInjectFirstTime = false;

    console.log("felaStylesInject: start");

    // const felaStylesMarkup = felaRenderer.renderToMarkup();
    const felaStylesMarkup = renderToMarkup(felaRenderer);

    console.log("felaStylesInject: felaStylesMarkup:", felaStylesMarkup);

    return Promise.resolve(felaStylesMarkup);
    // return Promise.resolve('__TEST_1__');
  });

  const resultWithFelaStyles = result.pipeThrough(felaStylesInject);

  return context.body(resultWithFelaStyles, 200, {
    // return context.body(result, 200, {
    "content-type": "text/html; charset=utf-8",
  });
});
if (import.meta.main) {
  serve(server.fetch);
}

if (server.importMap) {
  server.importMap.imports["/~/"] = "/_ultra/compiler/src/";
}

// console.log(server.importMap);

export default server;
