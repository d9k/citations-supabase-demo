// deno-lint-ignore-file no-explicit-any

import React, { lazy, ReactNode, Suspense } from "react";

import { Button, ColorSchemeScript } from '@mantine/core';

import useAsset from "ultra/hooks/use-asset.js";
import Spinner from "/~/shared/ui/spinner.tsx";

import { QueryClientProvider } from "@tanstack/react-query";

const Comments = lazy(() => import("/~/entities/ui/comments.tsx"));

import { QueryClient } from "@tanstack/react-query";
import { queryClient } from "./react-query/query-client.ts";
import { ComposeProviders } from "/~/shared/react/ComposeProviders.tsx";
import { DemoFelaColorBlock } from "/~/shared/ui/demoFelaColorBlock.tsx";

import { MantineProviderMod } from "./providers/individually/mantine.tsx";
import { HtmlTemplate } from "/~/widgets/templates/HtmlTemplate.tsx";
import { BodyProviders } from '/~/app/providers/body.tsx';

export type AppProps = {
  cache?: any;
}

export default function App({ cache }: AppProps) {
  console.log("Hello world!");
  return (
        <HtmlTemplate
          title="Ultra"
          addHeaderChildren={(
            <>
              <link rel="shortcut icon" href={useAsset("/favicon.ico")} />
              <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@mantine/core@7.1.2/esm/index.css" />
              <link rel="stylesheet" href={useAsset("/style.css")} />
              <ColorSchemeScript />
            </>
          )}
        >
          <BodyProviders>
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

              <DemoFelaColorBlock>Fela colored block content</DemoFelaColorBlock>

              <Button>__TEST__</Button>

              <h2>Comments:</h2>

              <Suspense fallback={<Spinner />}>
                <Comments date={+new Date()} />
              </Suspense>
            </main>
          </BodyProviders>
      </HtmlTemplate>
  );
}
