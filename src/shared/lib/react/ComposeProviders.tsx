// deno-lint-ignore-file no-explicit-any
import React, { JSXElementConstructor, ReactNode } from 'react';
import { WithChildren } from './WithChildren.ts';

// TODO array of generic parameters
// export type ProviderDataItem<P> = [
//   JSXElementConstructor<P>,
//   P
// ]
export type ProviderDataItem = [
  JSXElementConstructor<any>,
  any,
] | [JSXElementConstructor<any>];

export type CompositeProvidersProps = WithChildren & {
  providers: ProviderDataItem[];
};

export const ComposeProviders = (
  { providers, children }: CompositeProvidersProps,
) => {
  const C = providers.reduce(
    (Aggr, [Provider, providerProps = {}]) => ({ children }: WithChildren) => {
      return (
        <Aggr>
          <Provider {...providerProps}>
            {children}
          </Provider>
        </Aggr>
      );
    },
    ({ children }: WithChildren) => <>{children}</>,
  );

  return <C>{children}</C>;
};
