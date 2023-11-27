import { globToRegExp } from './globToRegExp.ts';

export const pathsFilterByGlobsArray = (
  paths: string[],
  globsArray: string[],
): string[] => {
  const regexArray = globsArray.map(globToRegExp);

  return paths.filter(
    (path: string) => !regexArray.some((regex) => regex.test(path)),
  );
};
