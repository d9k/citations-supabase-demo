/**
 * @see https://www.boredapi.com/documentation
 */

import { join } from 'std/path';
import { sleepRandomMs } from '/~/shared/lib/sys/sleep.ts';

const currentDir = Deno.cwd();
const demoDataBoredPath = join(
  currentDir,
  'src/shared/demo-data/tasks-from-bored-api.json',
);

const REQUESTS_COUNT = 10;
const PAUSE_MS_MIN = 20;
const PAUSE_MS_MAX = 500;

let fileData: object[] = [];

try {
  fileData = JSON.parse(Deno.readTextFileSync(demoDataBoredPath));
} catch (e) {
  console.error(e);
}

let result: object[] = [];

for (let reqNum = 1; reqNum <= REQUESTS_COUNT; reqNum++) {
  const response = await fetch('http://www.boredapi.com/api/activity');
  const newRecord = await response.json();
  result.push(newRecord);
  await sleepRandomMs(PAUSE_MS_MIN, PAUSE_MS_MAX);
}

console.log(result);

fileData = [...fileData, ...result];
const fileDataNewJSON = JSON.stringify(fileData, null, '  ');
Deno.writeTextFileSync(demoDataBoredPath, fileDataNewJSON);

console.log(
  `"${demoDataBoredPath}" updated and have ${fileData.length} records now`,
);
