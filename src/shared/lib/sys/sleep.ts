/**
 * https://github.com/michael-spengler/sleep
 */

import { randomRange } from '/~/shared/lib/math/random.ts';

export const sleepMs = (delayMs: number) =>
  new Promise((resolve) => setTimeout(resolve, delayMs));

export const sleepRandomMs = (
  minMs: number,
  maxMs: number,
) => sleepMs(randomRange(minMs, maxMs));
