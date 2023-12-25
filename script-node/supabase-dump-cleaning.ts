import { config as dotEnvConfig } from 'dotenv';

import { envValueRequire } from '/~/shared/lib/node/env';

import replaceInFile from 'replace-in-file';

dotEnvConfig();

const SUPABASE_DUMP_DATA_PATH = envValueRequire('SUPABASE_DUMP_DATA_PATH');

// const NO_CHANGE_JUST_TEST = true;
const NO_CHANGE_JUST_TEST = false;

const CLEANING_PATTERNS = [
  /INSERT INTO "auth"."audit_log_entries"[^;]+;/gm,
  /INSERT INTO "auth"."flow_state"[^;]+;/gm,
  /INSERT INTO "auth"."mfa_amr_claims"[^;]+;/gm,
  /INSERT INTO "auth"."refresh_tokens"[^;]+;/gm,

  /** Non-greedy https://stackoverflow.com/a/7124976/1760643 */
  /INSERT INTO "auth"\."sessions".+?\);/gms,
];

console.log(`Cleaning "${SUPABASE_DUMP_DATA_PATH}" with:`);
console.log(CLEANING_PATTERNS);

const result = replaceInFile.sync({
  files: SUPABASE_DUMP_DATA_PATH,
  from: CLEANING_PATTERNS,
  to: '',
  dry: NO_CHANGE_JUST_TEST,
  countMatches: true,
});

console.log(result);
