import type { StorybookConfig } from "@storybook/react-vite";
import { withoutVitePlugins } from '@storybook/builder-vite'
import path from 'path';

const config: StorybookConfig = {
  stories: ["../src/**/*.mdx", "../src/**/*.stories.@(js|jsx|mjs|ts|tsx)"],
  addons: [
    "@storybook/addon-links",
    "@storybook/addon-essentials",
    "@storybook/addon-onboarding",
    "@storybook/addon-interactions",
  ],
  framework: {
    name: "@storybook/react-vite",
    options: {},
  },
  docs: {
    autodocs: "tag",
  },
  viteFinal: async (config: any) => {
    console.log('viteFinal:', config);

    return {
      ...config,
      plugins: await withoutVitePlugins(config.plugins, ['node-externals']),
      resolve: {
        ...config.resolve,
        alias: {
          ...config.resolve?.alias,
          '/~': path.resolve(__dirname, '../src'),
        }
      },
    };
  },
};
export default config;
