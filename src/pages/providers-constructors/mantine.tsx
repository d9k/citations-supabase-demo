import {
  createTheme,
  MantineColorScheme,
  MantineProvider,
} from '@mantine/core';
import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';

// import { Button, MantineProvider, ColorSchemeScript, createTheme } from '@mantine/core';
// const theme = createTheme({
//   /** Put your mantine theme override here */
// });

export type MantineProviderModProps = Partial<WithChildren> & {
  defaultColorScheme?: MantineColorScheme;
};

const theme = createTheme({
  /** Put your mantine theme override here */
});

export function MantineProviderConstructor(
  { children, defaultColorScheme = 'dark' }: MantineProviderModProps,
) {
  return (
    <MantineProvider defaultColorScheme={defaultColorScheme} theme={theme}>
      {/* <MantineProvider defaultColorScheme="dark"> */}
      {children}
    </MantineProvider>
  );
}
