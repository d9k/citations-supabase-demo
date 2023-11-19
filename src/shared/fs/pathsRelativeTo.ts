import {
  relative,
} from 'std/path';

export const pathsRelativeTo = (paths: string[], relativeTo: string): string[] =>
  paths.map((path) => "./" + relative(relativeTo, path))