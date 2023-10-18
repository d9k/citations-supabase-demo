import { BodyProviders } from "/~/pages/providers/body.tsx";
import { WithChildren } from "/~/shared/react/WithChildren.tsx";

export const BodyLayout = ({ children }: WithChildren) => (
  <BodyProviders>
    {children}
  </BodyProviders>
);
