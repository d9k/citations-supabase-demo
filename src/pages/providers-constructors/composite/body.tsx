import { ReactNode } from 'react';
import { MantineProviderConstructor } from '../mantine.tsx';
import { ComposeProviders } from '/~/shared/lib/react/ComposeProviders.tsx';

export type BodyProvidersProps = {
  children: ReactNode;
};

export const BodyProvidersConstructor = ({ children }: BodyProvidersProps) => (
  <ComposeProviders
    providers={[
      // уже есть в server.ts, client.ts
      // [QueryClientProvider, {client: queryClient}],
      [MantineProviderConstructor],
      // [FelaRendererProvider]
    ]}
  >
    {
      /* <QueryClientProvider client={queryClient}>
    <MantineProviderMod> */
    }
    {/* <MantineProvider withGlobalStyles withNormalizeCSS> */}
    {/* <MantineProvider theme={theme}> */}
    {/* @ts-ignore Type 'ReactNode' is not assignable to type 'null | undefined'. */}
    {children}
  </ComposeProviders>
);
