import {
  globToRegExp as globToRegExpOrig,
} from 'std/path';

export const globToRegExp = (pattern: string) => globToRegExpOrig(pattern, {
  extended: true,
  globstar: true,
  caseInsensitive: false,
})