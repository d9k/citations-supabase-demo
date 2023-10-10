import { MantineProvider, createTheme } from '@mantine/core';
import { WithChildren } from "/~/shared/react/WithChildren.tsx";

export type MantineProviderModProps = Partial<WithChildren>;

const theme = createTheme({
  /** Put your mantine theme override here */
});

export function MantineProviderMod({ children }: MantineProviderModProps) {
  return (
    <MantineProvider theme={theme}>
      {children}
    </MantineProvider>
  );
}