import { createRenderer } from "fela";
// import { ThemeProvider } from "react-fela"
import { RendererProvider } from "/~/deps/react-fela/index.ts";
// import { RendererProvider } from "react-fela";

import { WithChildren } from "/~/shared/react/WithChildren.tsx";

import pluginValidator from "fela-plugin-validator";
// import pluginExpandShorthand from "fela-plugin-expand-shorthand";
import pluginUnit from "fela-plugin-unit";
import pluginExtend from "fela-plugin-extend";

// import pluginTypescript from 'fela-plugin-typescript';
import enhancerEnforceLonghands from "fela-enforce-longhands";

/** @see https://fela.js.org/docs/latest/advanced/renderer-configuration */
export const felaRenderer = createRenderer({
  // selectorPrefix: process.env.NODE_ENV !== 'production' ? 'fela_' : '';
  devMode: true,
  plugins: [
    /**
     * Required plugin order: fela v. 12+: unit, fallback-value, prefixer!
     * @see https://fela.js.org/docs/latest/extra/migration#12.0.0
     */
    pluginExtend(),
    pluginUnit(),
    // TODO
    // pluginTypescript(),
    pluginValidator(),
    // pluginExpandShorthand(true),
  ],
  enhancers: [
    enhancerEnforceLonghands({
      borderMode: "directional",
    }),
  ],
  selectorPrefix: "fela_",
});

console.log("providers/fela.tsx: renderer created");

export const FelaRendererProvider = ({ children }: WithChildren) => (
  <RendererProvider renderer={felaRenderer}>
    {children}
  </RendererProvider>
);
