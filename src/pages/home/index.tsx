import { Button } from "@mantine/core";
import { DemoFelaColorBlock } from "/~/shared/ui/demoFelaColorBlock.tsx";
import { Suspense } from "react";
import Comments from "/~/entities/ui/comments.tsx";
import { Spinner } from "/~/shared/ui/spinner.tsx";

const HomePage = () => (
  <main>
    <h1>
      <span></span>__<span></span>
    </h1>
    <p>
      Welcome to{" "}
      <strong>Ultra</strong>. This is a barebones starter for your web app.
    </p>
    <p>
      Take{" "}
      <a
        href="https://ultrajs.dev/docs"
        target="_blank"
      >
        this
      </a>, you may need it where you are going. It will show you how to
      customize your routing, data fetching, and styling with popular libraries.
    </p>
  </main>
);

export default HomePage;
