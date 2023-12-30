// import { BodyTemplate } from '../widgets/templates/BodyTemplate.tsx.bk';
import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';
import { AppProvidersConstructor } from '../pages/providers-constructors/composite/app.tsx';

export const AppWrapper = ({
  children,
}: WithChildren) => {
  return (
    <AppProvidersConstructor>
      {children}
    </AppProvidersConstructor>
  );
};
