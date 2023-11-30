import { BodyProvidersConstructor } from '/~/pages/providers-constructors/composite/body.tsx';
import { WithChildren } from '/~/shared/lib/react/WithChildren.tsx';

export const BodyLayout = ({ children }: WithChildren) => (
  <BodyProvidersConstructor>
    {children}
  </BodyProvidersConstructor>
);
