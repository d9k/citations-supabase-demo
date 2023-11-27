import { groupBy } from 'lodash';

import { globToRegExp } from './globToRegExp.ts';

type PathsSplitByDenoResult = {
  nodeFiles: string[];
  denoFiles: string[];
};

export const pathsSplitByDeno = (
  tsFilesPaths: string[],
  globsArray: string[],
): PathsSplitByDenoResult => {
  const regexArray = globsArray.map(globToRegExp);

  return {
    nodeFiles: [],
    denoFiles: [],
    ...groupBy(
      tsFilesPaths,
      (path: string) =>
        regexArray.some((regex) => regex.test(path))
          ? 'nodeFiles'
          : 'denoFiles',
    ),
  };
};
