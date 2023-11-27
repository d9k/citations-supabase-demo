import { createTheme, MantineProvider } from '@mantine/core';
import { WithChildren } from '/~/shared/lib/react/WithChildren.tsx';

// import { Button, MantineProvider, ColorSchemeScript, createTheme } from '@mantine/core';
// const theme = createTheme({
//   /** Put your mantine theme override here */
// });

export type MantineProviderModProps = Partial<WithChildren> & {
  defaultColorScheme?: string;
};

const theme = createTheme({
  /** Put your mantine theme override here */
});

export function MantineProviderMod(
  { children, defaultColorScheme = 'dark' }: MantineProviderModProps,
) {
  return (
    <MantineProvider defaultColorScheme={defaultColorScheme} theme={theme}>
      {/* <MantineProvider defaultColorScheme="dark"> */}
      {children}
    </MantineProvider>
  );
}
