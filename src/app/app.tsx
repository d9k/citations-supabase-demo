// deno-lint-ignore-file no-explicit-any

import React, { lazy, ReactNode, Suspense } from "react";
// import { Button, MantineProvider, ColorSchemeScript, createTheme } from '@mantine/core';
import { Button, ColorSchemeScript } from '@mantine/core';

import useAsset from "ultra/hooks/use-asset.js";
import Spinner from "/~/shared/ui/spinner.tsx";

import { QueryClientProvider } from "@tanstack/react-query";

const Comments = lazy(() => import("/~/entities/ui/comments.tsx"));

import { QueryClient } from "@tanstack/react-query";
import { queryClient } from "./react-query/query-client.ts";
import { ComposeProviders } from "/~/shared/react/ComposeProviders.tsx";
import { DemoFelaColorBlock } from "/~/shared/ui/demoFelaColorBlock.tsx";
// import { DemoScssColorBlock } from "/~/shared/ui/demoScssColorBlock/index.tsx";

// import { FELA_TEMPLATE_SERVER_RENDERED_STYLES, FelaRendererProvider } from "./providers/fela.tsx";
import { MantineProviderMod } from "./providers/mantine.tsx";
// const theme = createTheme({
//   /** Put your mantine theme override here */
// });

import { isServer } from "/~/shared/utils/isServer.ts";
import { WithChildren } from "/~/shared/react/WithChildren.tsx";


const HtmlProviders = ({children}: WithChildren) => (
  <ComposeProviders
    providers={[
      // уже есть!!!
      // [QueryClientProvider, {client: queryClient}],
      // [FelaRendererProvider]
    ]}
  >
    {/* @ts-ignore Type 'ReactNode' is not assignable to type 'null | undefined'. */}
    {children}
  </ComposeProviders>
);

const BodyProviders = ({children}: WithChildren) => (
  <ComposeProviders
    providers={[
      [MantineProviderMod],
    ]}
  >
    {/* @ts-ignore Type 'ReactNode' is not assignable to type 'null | undefined'. */}
    {children}
  </ComposeProviders>
);

export default function App({ cache }: any) {
  console.log("Hello world!");

  // const felaStyles = isServer() ? FELA_TEMPLATE_SERVER_RENDERED_STYLES : null;

  return (
    <HtmlProviders>
      <html lang="en">
        <head>
          <meta charSet="utf-8" />
          <title>Ultra</title>
          <meta name="viewport" content="width=device-width, initial-scale=1" />
          <link rel="shortcut icon" href={useAsset("/favicon.ico")} />
          <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@mantine/core@7.1.2/esm/index.css" />
          <link rel="stylesheet" href={useAsset("/style.css")} />
          {/* { felaStyles } */}
          <ColorSchemeScript />
        </head>
        <body>
          <BodyProviders>
          {/* <QueryClientProvider client={queryClient}>
          <MantineProviderMod> */}
          {/* <MantineProvider withGlobalStyles withNormalizeCSS> */}
          {/* <MantineProvider theme={theme}> */}
            <main>
              <h1>
                <span></span>__<span></span>
              </h1>
              <p>
                Welcome to{" "}
                <strong>Ultra</strong>. This is a barebones starter for your web
                app.
              </p>
              <p>
                Take{" "}
                <a
                  href="https://ultrajs.dev/docs"
                  target="_blank"
                >
                  this
                </a>, you may need it where you are going. It will show you how to
                customize your routing, data fetching, and styling with popular
                libraries.
              </p>

              {/* <DemoScssColorBlock>Scss colored block content</DemoScssColorBlock> */}
              <DemoFelaColorBlock>Fela colored block content</DemoFelaColorBlock>

              <Button>__TEST__</Button>

              <h2>Comments:</h2>

              <Suspense fallback={<Spinner />}>
                <Comments date={+new Date()} />
              </Suspense>
            </main>
            {/* </MantineProviderMod>
            </QueryClientProvider> */}
          </BodyProviders>
        </body>
      </html>
    </HtmlProviders>
  );
}
