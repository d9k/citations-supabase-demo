/**
 * Script to update VSCode config
 * Run with `deno task config`
 *
 * TODO remove after "deno.enablePaths: pattern support · Issue #834 of vscode_deno" fixed:
 * @see https://github.com/denoland/vscode_deno/issues/834
 */

import { join } from 'std/path';

import { getTsFilesPaths } from '/~/shared/lib/fs/getTsFilesPaths.ts';
import { pathsSplitByDeno } from '/~/shared/lib/fs/pathsSplitByDeno.ts';
import { pathsFilterByGlobsArray } from '/~/shared/lib/fs/pathsFilterByGlobsArray.ts';

const currentDir = Deno.cwd();
const vsCodeConfigPath = join(currentDir, '.vscode/settings.json');

const CONFIG_STRIP_GLOB_ARRAY = ['./src/**/**.tsx'];

const FILTERS_GLOB_ARRAY = [
  './**/*.stories.tsx',
];

const srcTsFilesPaths = getTsFilesPaths(join(currentDir, 'src'), currentDir);
const { denoFiles, nodeFiles } = pathsSplitByDeno(
  srcTsFilesPaths,
  FILTERS_GLOB_ARRAY,
);

console.debug('deno files:', denoFiles);
console.log('node files:', nodeFiles);

const vsCodeConfig = JSON.parse(Deno.readTextFileSync(vsCodeConfigPath));
console.debug('VS Code config:', vsCodeConfig);

const denoDisablePaths = vsCodeConfig['deno.disablePaths'] || [];

const denoDisablePathsStripped = pathsFilterByGlobsArray(
  denoDisablePaths,
  CONFIG_STRIP_GLOB_ARRAY,
);

console.log('denoDisablePaths stripped:', denoDisablePathsStripped);

const denoDisablePathsNew = [...denoDisablePathsStripped, ...nodeFiles];

const vsCodeConfigNew = {
  ...vsCodeConfig,
  'deno.disablePaths': denoDisablePathsNew,
};

const vsCodeConfigNewJSON = JSON.stringify(vsCodeConfigNew, null, '  ');

console.log('VS Code config new:', vsCodeConfigNewJSON);

Deno.writeTextFileSync(vsCodeConfigPath, vsCodeConfigNewJSON);
