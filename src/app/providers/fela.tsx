import { createRenderer } from "fela";

import { RendererProvider } from "/~/deps/react-fela/index.ts"
import { WithChildren } from "/~/shared/react/WithChildren.tsx";


/** @see https://fela.js.org/docs/latest/advanced/renderer-configuration */
const renderer = createRenderer({
  // selectorPrefix: process.env.NODE_ENV !== 'production' ? 'fela_' : '';
  // selectorPrefix: process.env.NODE_ENV !== 'production' ? 'fela_' : '';
  // devMode: true,
  // selectorPrefix: 'fela_',
});

export const FelaRendererProvider = ({children}: WithChildren) => (
  <RendererProvider renderer={renderer}>
    {children}
  </RendererProvider>
)