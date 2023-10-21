// deno-lint-ignore-file no-explicit-any

import React, { lazy, Suspense } from "react";
import { Button } from "@mantine/core";
import { Spinner } from "/~/shared/ui/spinner.tsx";
import { DemoFelaColorBlock } from "/~/shared/ui/demoFelaColorBlock.tsx";
import { AppRoutes } from "/~/app/routes/index.tsx";
import { HtmlTemplate } from "/~/widgets/templates/HtmlTemplate.tsx";
import { ColorSchemeScript } from "@mantine/core";
import useAsset from "ultra/hooks/use-asset.js";
import { BodyProviders } from "/~/pages/providers/body.tsx";
import { commonHeaderScriptsArray } from "/~/app/templates/headerScripts.tsx";

const Comments = lazy(() => import("/~/entities/ui/comments.tsx"));

export type AppProps = {
  cache?: any;
};

export default function App({ cache }: AppProps) {
  console.log("Hello world!");
  return (
    <HtmlTemplate
      title="Ultra"
      addHeaderChildren={
        <>
          <link rel="shortcut icon" href={useAsset("/favicon.ico")} />
          {commonHeaderScriptsArray()}
          <ColorSchemeScript />
        </>
      }
    >
      <BodyProviders>
        <AppRoutes />
      </BodyProviders>
    </HtmlTemplate>
  );
}
