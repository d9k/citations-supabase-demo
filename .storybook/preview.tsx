import type { Preview } from '@storybook/react';
import { FelaRendererProviderConstructor } from '../src/app/providers-constructors/fela.tsx';
import { MantineProviderConstructor } from '../src/pages/providers-constructors/mantine.tsx';
import { Helmet, HelmetProvider } from 'react-helmet-async';
import { commonHeaderScriptsArray } from '/~/app/templates/headerScripts';
import { MantineColorSchemeScript } from '/~/pages/providers-constructors/helpers/colorSchemeScript.tsx';
import { useMantineColorScheme } from '@mantine/core';
import React, { useEffect } from 'react';
import { useDarkMode } from 'storybook-dark-mode';
import { DocsContainer } from '@storybook/addon-docs';
import { themes } from '@storybook/theming';

console.log('preview.tsx');

type DocsContainerProps = Parameters<typeof DocsContainer>[0];

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
      container: (props: DocsContainerProps) => {
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
    (Story) => {
      const { setColorScheme } = useMantineColorScheme();
      const darkMode = useDarkMode() ?? true;
      const mantineTheme = darkMode ? 'dark' : 'light';

      useEffect(() => {
        setColorScheme(mantineTheme);
      }, [darkMode]);

      return <Story />;
    },
    (Story) => {
      return (
        <HelmetProvider>
          <FelaRendererProviderConstructor>
            <>
              <Helmet>
                {commonHeaderScriptsArray()}
              </Helmet>
              <MantineColorSchemeScript />
              <MantineProviderConstructor defaultColorScheme='dark'>
                <Story />
              </MantineProviderConstructor>
            </>
          </FelaRendererProviderConstructor>
        </HelmetProvider>
      );
    },
  ],
};

export default preview;
