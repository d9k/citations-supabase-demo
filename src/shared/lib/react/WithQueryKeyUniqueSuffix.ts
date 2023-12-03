import { randomRange } from '/~/shared/lib/math/random.ts';

export type WithQueryKeyUniqueSuffix = {
  queryKeyUniqueSuffix: string;
};

export const generateQueryKeyUniqueSuffix = (): string =>
  `${+new Date()}_${randomRange(0, 100000)}`;
