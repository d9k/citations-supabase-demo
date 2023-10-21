import { createTheme, MantineProvider } from "@mantine/core";
import { WithChildren } from "/~/shared/react/WithChildren.tsx";

// import { Button, MantineProvider, ColorSchemeScript, createTheme } from '@mantine/core';
// const theme = createTheme({
//   /** Put your mantine theme override here */
// });

export type MantineProviderModProps = Partial<WithChildren>;

const theme = createTheme({
  /** Put your mantine theme override here */
});

export function MantineProviderMod({ children }: MantineProviderModProps) {
  return (
    <MantineProvider defaultColorScheme="dark" theme={theme}>
      {children}
    </MantineProvider>
  );
}
