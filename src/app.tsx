// deno-lint-ignore-file no-explicit-any
import React, { lazy, Suspense } from "react";
// import { Button, MantineProvider, ColorSchemeScript, createTheme } from '@mantine/core';
import { Button } from '@mantine/core';
import { MantineProviderMod } from "/~/providers/mantine.tsx";

import useAsset from "ultra/hooks/use-asset.js";
import Spinner from "/~/components/spinner.tsx";

import { QueryClientProvider } from "@tanstack/react-query";

const Comments = lazy(() => import("/~/components/comments.tsx"));

import { QueryClient } from "@tanstack/react-query";
import { queryClient } from "/~/react-query/query-client.ts";

// const theme = createTheme({
//   /** Put your mantine theme override here */
// });

export default function App({ cache }: any) {
  console.log("Hello world!");
  return (
      <html lang="en">
        <head>
          <meta charSet="utf-8" />
          <title>Ultra</title>
          <meta name="viewport" content="width=device-width, initial-scale=1" />
          <link rel="shortcut icon" href={useAsset("/favicon.ico")} />
          <link rel="stylesheet" href={useAsset("/style.css")} />
          {/* <ColorSchemeScript /> */}
        </head>
        <body>
          <QueryClientProvider client={queryClient}>
          {/* <MantineProvider withGlobalStyles withNormalizeCSS> */}
          <MantineProviderMod>
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

              <Button>__TEST__</Button>

              <h2>Comments:</h2>

              <Suspense fallback={<Spinner />}>
                <Comments date={+new Date()} />
              </Suspense>
            </main>
            </MantineProviderMod>
            </QueryClientProvider>
        </body>
      </html>
  );
}
