import * as dotenv from 'dotenv';

import {
  envGetNonRequired,
  envNameRequire,
  envValueRequire,
} from '/~/shared/lib/deno/env.ts';

await dotenv.load({ export: true });

const DB_HOST = envValueRequire('DB_HOST');
const DB_NAME = envValueRequire('DB_NAME');
const DB_PORT = envValueRequire('DB_PORT');
const DB_USER = envValueRequire('DB_USER');
const DB_PASSWORD = envNameRequire('DB_PASSWORD');

const SUPABASE_PG_DUMP_PATH = envValueRequire('SUPABASE_PG_DUMP_PATH');

const newProcessEnv: Record<string, string> = {};

const PATH = envGetNonRequired('PATH');

if (DB_PASSWORD) {
  console.log('Passing password');
  newProcessEnv['PGPASSWORD'] = DB_PASSWORD;
}

if (PATH) {
  // console.debug('Setting PATH to', PATH);
  newProcessEnv['PATH'] = PATH;
}

const command = new Deno.Command('pg_dump', {
  args: [
    `--username=${DB_USER}`,
    `--host=${DB_HOST}`,
    `--port=${DB_PORT}`,
    // '--format=directory',
    '--format=plain',
    '--compress=none',
    '--exclude-table-data-and-children=auth.audit_log_entries',
    '--exclude-table-data-and-children=auth.mfa_amr_claims',
    '--exclude-table-data-and-children=auth.refresh_tokens',
    '--exclude-table-data-and-children=auth.sessions',
    `--file=${SUPABASE_PG_DUMP_PATH}`,
    DB_NAME,
  ],
  env: newProcessEnv,
  stdout: 'piped',
  stderr: 'piped',
});

const process = command.spawn();

const pipeToOptions: StreamPipeOptions = {
  preventClose: true,
  preventCancel: true,
  preventAbort: true,
};

process.stdout.pipeTo(Deno.stdout.writable, pipeToOptions);
process.stderr.pipeTo(Deno.stderr.writable, pipeToOptions);

const { success, code, signal } = await process.status;

// const { code, stdout, stderr } = await command.output();
// console.log('code:', command);
// console.log('stdout:', new TextDecoder().decode(stdout));
// console.log('stderr', new TextDecoder().decode(stderr));

// streams.copy(stdout, Deno.stdout);
// streams.copy(stderr, Deno.stderr);

// Deno.close(process.pid)

// try {
//   process.kill();
// } catch (e) {
//   console.error(e);
// }

console.log(`Done! success: ${success}, code: ${code}, signal: ${signal}`);
