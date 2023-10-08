import { createRenderer } from "fela"
import { RendererProvider } from "/~/deps/react-fela/index.ts"
import { WithChildren } from "/~/shared/react/WithChildren.tsx";

const renderer = createRenderer();

export const FelaRendererProvider = ({children}: WithChildren) => (
  <RendererProvider renderer={renderer}>
    {children}
  </RendererProvider>
)