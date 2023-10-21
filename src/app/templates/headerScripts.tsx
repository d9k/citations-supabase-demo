// TODO problems with Storybook
// import useAsset from "ultra/hooks/use-asset.js";

export const commonHeaderScriptsArray = () => (
  [
    <link
      key="mantine-core"
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/@mantine/core@7.1.2/esm/index.css"
    />,
    <link
      key="common-app-styles"
      rel="stylesheet"
      href="/style.css"
    />
  ]
)