import type { StorybookConfig } from '@storybook/react-vite';
import { withoutVitePlugins } from '@storybook/builder-vite';
import path from 'path';
import { InlineConfig as ViteInlineConfig } from 'vite';

const config: StorybookConfig = {
  stories: ['../src/**/*.mdx', '../src/**/*.stories.@(js|jsx|mjs|ts|tsx)'],
  addons: [
    '@storybook/addon-links',
    '@storybook/addon-essentials',
    '@storybook/addon-onboarding',
    '@storybook/addon-interactions',
    'storybook-dark-mode',
  ],
  framework: {
    name: '@storybook/react-vite',
    options: {},
  },
  docs: {
    autodocs: 'tag',
  },
  typescript: {
    reactDocgenTypescriptOptions: {
      shouldRemoveUndefinedFromOptional: true,
      shouldExtractLiteralValuesFromEnum: true,

      /** @see https://github.com/storybookjs/storybook/issues/12185#issuecomment-749531020 */
      propFilter: (prop) => {
        // console.log('__TEST__', prop);
        if (prop.parent) {
          const fileName = prop.parent.fileName;
          if (/node_modules/.test(fileName)) {
            if (/@mantine/.test(fileName)) {
              /** Some shorthand or service property */
              if (
                prop.name.length <= 3 || prop.name.at(0) == '_' ||
                prop.name == 'bgsz'
              ) {
                return false;
              }
              return true;
            }
            return false;
          } else {
            return true;
          }
        }

        return true;
      },
    },
  },
  viteFinal: async (config: ViteInlineConfig): Promise<ViteInlineConfig> => {
    console.log('viteFinal:', config);

    return {
      ...config,
      plugins: await withoutVitePlugins(config.plugins, ['node-externals']),
      resolve: {
        ...config.resolve,
        alias: {
          ...config.resolve?.alias,
          '/~': path.resolve(__dirname, '../src'),
        },
      },
    };
  },
};
export default config;
