/**
 * TODO deprecate when Ultra builder (mesozoic) will support imports with aliases:
 * See
 * - https://github.com/exhibitionist-digital/ultra/issues/290
 * - https://github.com/deckchairlabs/mesozoic/issues/17
 *
 * This script copies sources to separate folder and transforms absolute imports to relative there.
 * Regex are hardcoded and support only `"/~/": "./src/"` alias
 */
import * as dotenv from 'dotenv';
import { envValueRequire } from '/~/shared/lib/deno/env.ts';

// TODO https://github.com/Isitea/regex-copy/issues/1
// "regex-copy": "https://deno.land/x/regex_copy@1.0.3/mod.ts",
// import { regexCopy } from 'regex-copy';

import * as path from 'std/path';
import * as fs from 'std/fs';

import wrench from 'wrench-js';

import { globToRegExp } from '/~/shared/lib/fs/globToRegExp.ts';

await dotenv.load({ export: true });

const PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH = envValueRequire(
  'PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH',
);

import { ReplaceCallback } from '/~/shared/lib/strings/types.ts';

const projectPath = Deno.cwd();

const SCRIPTS_GLOB_ARRAY = ['**/*.ts{,x}', '**/*.js{,x}'];

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
  const result = [
    // TODO proper regex create
    new RegExp(PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH),
    /^\.git$/,
    /^\.git$/,
    /^\.storybook$/,
    /^\.ultra$/,
    /^node_modules$/,
    /^supabase$/,
    /^supabase$/,
  ].some((rgx) => rgx.test(fileRelPath));
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
    excludeHiddenUnix: false, // Whether to copy hidden Unix files or not (preceding .)
    preserveFiles: false, // If we're overwriting something and the file already exists, keep the existing
    preserveTimestamps: true, // Preserve the mtime and atime when copying files
    inflateSymlinks: false, // Whether to follow symlinks or not when copying files
    // filter: [/node_modules/], // A filter to match files against; if matches, do nothing (exclude).
    whitelist: false, // if true every file or directory which doesn't match filter will be ignored
    // include: regexpOrFunction, // An include filter (either a regexp or a function)
    exclude: checkExclude, // An exclude filter (either a regexp or a function)
  },
);

const matchScriptsRegexArray = SCRIPTS_GLOB_ARRAY.map(globToRegExp);

const aliasSrcAbsPath = path.join(
  PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH,
  'src',
);

const walkIterator = fs.walk(
  PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH,
  {
    match: matchScriptsRegexArray,
  },
);

for await (const scriptFileEntry of walkIterator) {
  const scriptAbsPath = scriptFileEntry.path;

  const scriptRelPath = path.relative(
    PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH,
    scriptAbsPath,
  );

  const scriptDirPath = path.dirname(scriptAbsPath);

  console.debug('walk scripts:', scriptRelPath, scriptFileEntry.path);

  const codeLines = Deno.readTextFileSync(scriptFileEntry.path);

  const replaceQuotedPath: ReplaceCallback = (
    _quotedPath,
    importPathWithAlias,
  ) => {
    console.debug('    ', importPathWithAlias);

    const importPathAbs = importPathWithAlias.replace(/^\/~\//, () => {
      return aliasSrcAbsPath + '/';
    });

    const importPathRelativeToScript = path.relative(
      scriptDirPath,
      importPathAbs,
    );

    const importPathRelativeToScriptStartsWithDot =
      importPathRelativeToScript.match(/^\.\./)
        ? importPathRelativeToScript
        : `./${importPathRelativeToScript}`;

    return `'${importPathRelativeToScriptStartsWithDot}'`;
  };

  const transformStringWithQuotedPath = (stringWithQuotedPath: string) => {
    const transformedString = stringWithQuotedPath.replace(
      /'(.*)'/,
      replaceQuotedPath,
    );

    console.debug('->', transformedString);

    return transformedString;
  };

  const codeLinesWithRelImports = codeLines.replace(
    /from[\s\n\r]+'\/~\/.*'/gm,
    (fromWithQuotedPath) => {
      console.debug('  ', fromWithQuotedPath);

      return transformStringWithQuotedPath(fromWithQuotedPath);
    },
    /** async import */
  ).replace(/import\([\s\n\r]*'\/~\/.*'/gm, (fromWithQuotedPath) => {
    console.debug('  ', fromWithQuotedPath);

    return transformStringWithQuotedPath(fromWithQuotedPath);
  });

  Deno.writeTextFileSync(scriptAbsPath, codeLinesWithRelImports);
}
