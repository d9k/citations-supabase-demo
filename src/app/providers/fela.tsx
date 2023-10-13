import { createRenderer } from "fela";

// import { RendererProvider, ThemeProvider } from "react-fela"
import { RendererProvider } from "react-fela"
// import { RendererProvider } from "/~/deps/react-fela/index.ts"
import { WithChildren } from "/~/shared/react/WithChildren.tsx";


/** @see https://fela.js.org/docs/latest/advanced/renderer-configuration */
export const felaRenderer = createRenderer({
  // selectorPrefix: process.env.NODE_ENV !== 'production' ? 'fela_' : '';
  // selectorPrefix: process.env.NODE_ENV !== 'production' ? 'fela_' : '';
  devMode: true,
  selectorPrefix: 'fela_',
});

console.log('providers/fela.tsx: renderer created');

export const FelaRendererProvider = ({children}: WithChildren) => (
  <RendererProvider renderer={felaRenderer}>
    {children}
  </RendererProvider>
)