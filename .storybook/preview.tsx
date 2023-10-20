import type { Preview } from "@storybook/react";
import { FelaRendererProvider } from "/~/app/providers/individually/fela.tsx";
import { MantineProviderMod } from "/~/pages/providers/individually/mantine.tsx";

import '../public/style.css'

console.log('preview.tsx');

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
        <FelaRendererProvider>
          <MantineProviderMod>
            <Story />
          </MantineProviderMod>
        </FelaRendererProvider>
      // </div>
    ),
  ],
};

export default preview;
