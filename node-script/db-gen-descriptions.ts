import postgres from 'postgres';
import { config } from 'dotenv';
import set from 'lodash/set';
import * as fs from 'fs';

const outDescriptionsPath =
  'src/shared/api/supabase/descriptions.generated.json';

config();

const {
  DB_HOST,
  DB_NAME,
  DB_PORT,
  DB_USER,
  DB_PASSWORD,
} = process.env;

console.log({
  DB_HOST,
  DB_NAME,
  DB_PORT,
  DB_USER,
  DB_PASSWORD,
});

if (!DB_HOST) {
  throw Error('DB_HOST not set');
}

if (!DB_PORT) {
  throw Error('DB_PORT not set');
}

if (!DB_USER) {
  throw Error('DB_USER not set');
}

if (!DB_NAME) {
  throw Error('DB_NAME not set');
}

const DB_PORT_INT = parseInt(DB_PORT, 10);

const sql = postgres({
  host: DB_HOST,
  port: DB_PORT_INT,
  database: DB_NAME,
  username: DB_USER,
  password: DB_PASSWORD,
});

async function genDescription() {
  // thanks https://stackoverflow.com/a/1152321/1760643
  const queryResult = await sql`
    select
      c.table_schema,
      c.table_name,
      c.column_name,
      pgd.description
    from pg_catalog.pg_statio_all_tables as st
    inner join pg_catalog.pg_description pgd on (
      pgd.objoid = st.relid
    )
    inner join information_schema.columns c on (
      pgd.objsubid   = c.ordinal_position and
      c.table_schema = st.schemaname and
      c.table_name   = st.relname
    );
  `;

  const result = {};

  queryResult.map(({ table_schema, table_name, column_name, description }) => {
    const valuePath = [table_schema, table_name, column_name];
    set(result, valuePath, description);
  });

  const resultJSON = JSON.stringify(result, null, '  ');

  console.log(`Saving to ${outDescriptionsPath}`);
  fs.writeFileSync(outDescriptionsPath, resultJSON);

  return true;
}

async function main() {
  const timerToPreventFreeze = setTimeout(() => {}, 999999);
  await genDescription();
  clearTimeout(timerToPreventFreeze);
}

main().then(() => {
  process.exit();
});
