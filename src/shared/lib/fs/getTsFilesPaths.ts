import { pathsRelativeTo } from './pathsRelativeTo.ts';
import { getTsFilesAbsPaths } from './getTsFilesAbsPaths.ts';

export const getTsFilesPaths = (path: string, relativeTo: string): string[] =>
  pathsRelativeTo(getTsFilesAbsPaths(path), relativeTo);
