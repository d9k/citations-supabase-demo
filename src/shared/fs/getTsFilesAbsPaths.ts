import { walkSync } from 'std/fs';

export const getTsFilesAbsPaths = (path: string) =>
  [...walkSync(path, {
    exts: ['ts', 'tsx'],
  })].filter((entry) => {
    return entry.isFile;
  }).map((entry) => entry.path)