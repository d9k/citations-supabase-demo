import type { Preview } from '@storybook/react';
import { FelaRendererProvider } from '/~/app/providers/individually/fela.tsx';
import { MantineProviderMod } from '/~/pages/providers/individually/mantine.tsx';
import { Helmet, HelmetProvider } from 'react-helmet-async';
import { commonHeaderScriptsArray } from '/~/app/templates/headerScripts';
import { MantineColorSchemeScript } from '/~/pages/providers/helpers/colorSchemeScript';
import { useMantineColorScheme } from '@mantine/core';
import { useEffect } from 'react';

// import '../public/style.css'
// import 'https://cdn.jsdelivr.net/npm/@mantine/core@7.1.2/esm/index.css'

const THEME_DEFAULT = 'dark';

console.log('preview.tsx');
// <>
//   {/* <CommonHeaderScripts /> */}
//   <link
//     rel="stylesheet"
//     href="https://cdn.jsdelivr.net/npm/@mantine/core@7.1.2/esm/index.css"
//   />
//   <link rel="stylesheet" href="/style.css" />
// </>
const preview: Preview = {
  parameters: {
    actions: { argTypesRegex: '^on[A-Z].*' },
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
    },
  },
  decorators: [
    (Story: any, { globals: { theme = THEME_DEFAULT } }) => {
      const { setColorScheme } = useMantineColorScheme();

      useEffect(() => {
        setColorScheme(theme);
      }, [theme]);

      return <Story />;
    },
    (Story: any, { globals: { theme = THEME_DEFAULT } }) => {
      return (
        // <div style={{ padding: '3rem', backgroundColor: 'blue' }}>
        <HelmetProvider>
          <FelaRendererProvider>
            <>
              <Helmet>
                {commonHeaderScriptsArray()}
              </Helmet>
              <MantineColorSchemeScript />
              <MantineProviderMod defaultColorScheme={theme}>
                <Story />
              </MantineProviderMod>
            </>
          </FelaRendererProvider>
        </HelmetProvider>
        // </div>
      );
    },
  ],
  globalTypes: {
    theme: {
      name: 'Theme',
      description: 'Theme for the components',
      defaultValue: THEME_DEFAULT,
      toolbar: {
        icon: 'circlehollow',
        items: [
          { value: 'light', icon: 'circlehollow', title: 'light' },
          { value: 'dark', icon: 'circle', title: 'dark (default)' },
        ],
      },
    },
  },
};

export default preview;
