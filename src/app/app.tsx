// deno-lint-ignore-file no-explicit-any

import { lazy, Suspense } from "react";
import { Button } from '@mantine/core';
import Spinner from "/~/shared/ui/spinner.tsx";
import { DemoFelaColorBlock } from "/~/shared/ui/demoFelaColorBlock.tsx";
import { RootLayout } from '/~/pages/layouts/RootLayout.tsx';

const Comments = lazy(() => import("/~/entities/ui/comments.tsx"));

export type AppProps = {
  cache?: any;
}

export default function App({ cache }: AppProps) {
  console.log("Hello world!");
  return (
    <RootLayout>
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
    </RootLayout>
  );
}
