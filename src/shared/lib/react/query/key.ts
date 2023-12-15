import { useState } from 'react';
import { randomRange } from '/~/shared/lib/math/random.ts';
import { useCallback } from 'react';

export type WithQueryKeyUniqueSuffix = {
  queryKeyUniqueSuffix: string;
};

export const generateQueryKeyUniqueSuffix = (): string =>
  `${+new Date()}_${randomRange(0, 100000)}`;

export const useQueryKeyUniqueSuffix = (): [string, () => void] => {
  const [key, setKey] = useState(generateQueryKeyUniqueSuffix());

  const regenerate = useCallback(() => {
    setKey(generateQueryKeyUniqueSuffix());
  }, [setKey]);

  return [
    key,
    regenerate,
  ];
};
