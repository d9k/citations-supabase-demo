import * as dotenv from 'dotenv';

import { envValueRequire } from '/~/shared/lib/deno/env.ts';

import { runCommandWithPipedOutput } from '/~/shared/lib/deno/run.ts';
import * as path from 'std/path';

await dotenv.load({ export: true });

const PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH = envValueRequire(
  'PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH',
);

const buildOutput = path.join(
  PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH,
  '.ultra',
);

await runCommandWithPipedOutput('deno', [
  'task',
  'prebuild:copy-and-transform-imports-to-relative',
]);

await runCommandWithPipedOutput('deno', [
  'task',
  'build',
], { cwd: PROJECT_COPY_WITH_IMPORTS_TRANSFORMED_TO_RELATIVE_PATH });

await runCommandWithPipedOutput('deno', [
  'task',
  'start',
], { cwd: buildOutput, env: { ULTRA_LOG_LEVEL: 'DEBUG' } });
