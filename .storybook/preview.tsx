import type { Preview } from '@storybook/react';
import { FelaRendererProvider } from '/~/app/providers/individually/fela.tsx';
import { MantineProviderMod } from '/~/pages/providers/individually/mantine.tsx';
import { Helmet, HelmetProvider } from 'react-helmet-async';
import { commonHeaderScriptsArray } from '/~/app/templates/headerScripts';
import { MantineColorSchemeScript } from '/~/pages/providers/helpers/colorSchemeScript';
import { useMantineColorScheme } from '@mantine/core';
import React, { useEffect } from 'react';
import { useDarkMode } from 'storybook-dark-mode';
import { DocsContainer } from '@storybook/addon-docs';
import { themes } from '@storybook/theming';

console.log('preview.tsx');

const preview: Preview = {
  parameters: {
    actions: { argTypesRegex: '^on[A-Z].*' },
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
    },
    darkMode: {
      current: 'dark',
    },
    docs: {
      container: (props: any) => {
        const isDark = useDarkMode();
        const currentProps = { ...props };
        currentProps.theme = isDark ? themes.dark : themes.light;
        return React.createElement(DocsContainer, currentProps);
      },
    },
    options: {
      storySort: {
        order: ['Features', 'Shared', 'Demo', '*'],
      },
    },
  },
  decorators: [
    (Story: any) => {
      const { setColorScheme } = useMantineColorScheme();
      const darkMode = useDarkMode() ?? true;
      const mantineTheme = darkMode ? 'dark' : 'light';

      useEffect(() => {
        setColorScheme(mantineTheme);
      }, [darkMode]);

      return <Story />;
    },
    (Story: any) => {
      return (
        <HelmetProvider>
          <FelaRendererProvider>
            <>
              <Helmet>
                {commonHeaderScriptsArray()}
              </Helmet>
              <MantineColorSchemeScript />
              <MantineProviderMod defaultColorScheme='dark'>
                <Story />
              </MantineProviderMod>
            </>
          </FelaRendererProvider>
        </HelmetProvider>
      );
    },
  ],
};

export default preview;
