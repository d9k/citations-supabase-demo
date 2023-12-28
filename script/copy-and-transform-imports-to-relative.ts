import * as dotenv from 'dotenv';
import { envValueRequire } from '/~/shared/lib/deno/env.ts';

// TODO https://github.com/Isitea/regex-copy/issues/1
// "regex-copy": "https://deno.land/x/regex_copy@1.0.3/mod.ts",
// import { regexCopy } from 'regex-copy';

import * as path from 'std/path';

import wrench from 'wrench-js';

await dotenv.load({ export: true });

const PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH = envValueRequire(
  'PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH',
);

const projectPath = Deno.cwd();

console.log(
  `Copying ${projectPath} to ${PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH}`,
);

console.log(wrench);

try {
  Deno.removeSync(PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH, {
    recursive: true,
  });
} catch (e) {
  if (!(e instanceof Deno.errors.NotFound)) {
    throw e;
  }
}

// try {
//   Deno.mkdirSync(PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH);
// } catch (e) {
//   if (!(e instanceof Deno.errors.AlreadyExists)) {
//     throw e;
//   }
// }

// await regexCopy(
//   [projectPath, PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH],
//   {
//     removeEmpty: false,
//     test: TEST_ONLY_NO_COPY,
//     /** empty destination before copying */
//     reset: true,
//     // exclude: [/.+/, '**/*.stories.tsx'],
//   },
// );

function checkExclude(filename: string, dir: string) {
  const filePath = path.join(dir, filename);

  const fileRelPath = path.relative(projectPath, filePath);
  console.debug('checkExclude:', fileRelPath, filename, dir);
  const result = /^node_modules$/.test(fileRelPath) ||
    /^supabase$/.test(fileRelPath);
  if (result) {
    console.debug('checkExclude: Skipping');
  }
  return result;
}

wrench.copyDirSyncRecursive(
  projectPath,
  PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH,
  {
    forceDelete: true, // Whether to overwrite existing directory or not
    excludeHiddenUnix: true, // Whether to copy hidden Unix files or not (preceding .)
    preserveFiles: false, // If we're overwriting something and the file already exists, keep the existing
    preserveTimestamps: true, // Preserve the mtime and atime when copying files
    inflateSymlinks: false, // Whether to follow symlinks or not when copying files
    // filter: [/node_modules/], // A filter to match files against; if matches, do nothing (exclude).
    whitelist: false, // if true every file or directory which doesn't match filter will be ignored
    // include: regexpOrFunction, // An include filter (either a regexp or a function)
    exclude: checkExclude, // An exclude filter (either a regexp or a function)
  },
);
