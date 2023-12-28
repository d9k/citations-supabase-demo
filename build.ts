import { createBuilder } from 'ultra/build.ts';

const builder = createBuilder({
  browserEntrypoint: import.meta.resolve('./client.tsx'),
  serverEntrypoint: import.meta.resolve('./server.tsx'),
});

builder.ignore([
  './README.md',
  './importMap.json',
  './.git/**',
  './.vscode/**',
  './.github/**',
  './.gitignore',
  './.project-copy-with-imports-transformed-to-relative/',
  './node_modules/**',
  './script-node/**',
  './src/shared/lib/node/**',
  './src/shared/lib/storybook/**',
  './src/shared/demoStories/**',
  /** Must be updated with `deno task config` then copied from .vscode/settings.json */
  './src/features/auth/LoginForm.tdd.stories.tsx',
  './src/features/auth/RegisterForm.stories.tsx',
  './src/features/auth/LoginForm.stories.tsx',
  './src/shared/demo-stories/demoFelaColorBlock.stories.tsx',
  './src/shared/demo-stories/DemoMantineForm.stories.tsx',
  './src/shared/ui/spinner.stories.tsx',
  './src/shared/ui/layout-header.stories.tsx',
  './src/shared/ui/data-grid/data-grid.stories.tsx',
]);

// deno-lint-ignore no-unused-vars
const result = await builder.build();
