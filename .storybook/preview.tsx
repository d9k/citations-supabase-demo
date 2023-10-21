import type { Preview } from "@storybook/react";
import { FelaRendererProvider } from "/~/app/providers/individually/fela.tsx";
import { MantineProviderMod } from "/~/pages/providers/individually/mantine.tsx";
import { Helmet, HelmetProvider } from 'react-helmet-async';
import { commonHeaderScriptsArray } from "/~/app/templates/headerScripts";
import { ColorSchemeScript } from "@mantine/core";

// import '../public/style.css'
// import 'https://cdn.jsdelivr.net/npm/@mantine/core@7.1.2/esm/index.css'

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
    actions: { argTypesRegex: "^on[A-Z].*" },
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
    },
  },
  decorators: [
    (Story: any) => (
      // <div style={{ padding: '3rem', backgroundColor: 'blue' }}>
      <HelmetProvider>
        <FelaRendererProvider>
            <>
              <Helmet>
                {commonHeaderScriptsArray()}
              </Helmet>
              <ColorSchemeScript defaultColorScheme="dark" />
              <MantineProviderMod>
                <Story />
              </MantineProviderMod>
            </>
        </FelaRendererProvider>
      </HelmetProvider>
      // </div>
    ),
  ],
};

export default preview;
