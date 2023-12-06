import postgres from 'postgres';
// import { SchemaConverter } from 'pg-tables-to-jsonschema';
import { config } from 'dotenv';
import set from 'lodash/set';
import * as fs from 'fs';

// const outSchemaDir = 'src/shared/api/supabase/schema.generated';
const outForeignKeysPath =
  'src/shared/api/supabase/foreign-keys.generated.json';

import pgStructure from 'pg-structure';

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

// const converter = new SchemaConverter({
//   pg: {
//     host: DB_HOST,
//     port: DB_PORT_INT,
//     user: DB_USER,
//     password: DB_PASSWORD,
//     database: DB_NAME,
//   },
//   input: {
//     schemas: ['public'],
//     exclude: ['not_this_table'],
//     include: [],
//   },
//   output: {
//     additionalProperties: false,
//     // baseUrl: 'http://api.localhost.com/schema/',
//     // defaultDescription: 'Missing description',
//     defaultDescription: '',
//     indentSpaces: 2,
//     outDir: outSchemaDir,
//     unwrap: false,
//   },
// });

const sql = postgres({
  host: DB_HOST,
  port: DB_PORT_INT,
  database: DB_NAME,
  username: DB_USER,
  password: DB_PASSWORD,
});

async function genSchema() {
  // const result = await converter.convert();
  const result = await pgStructure({
    host: DB_HOST,
    database: DB_NAME,
    user: DB_USER,
    password: DB_PASSWORD,
  }, { includeSchemas: ['public'] });
  console.debug(result);
  return true;
}

async function genForeignKeys() {
  // thanks https://stackoverflow.com/a/1152321/1760643
  const queryResult = await sql`
    SELECT
      tc.table_schema,
      tc.constraint_name,
      tc.table_name,
      kcu.column_name,
      ccu.table_schema AS foreign_table_schema,
      ccu.table_name AS foreign_table_name,
      ccu.column_name AS foreign_column_name
    FROM information_schema.table_constraints AS tc
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
    WHERE tc.constraint_type = 'FOREIGN KEY'
    --    AND tc.table_schema='public'
    --    AND tc.table_name='mytable';
  `;

  const result = {};
  queryResult.map(({ column_name, table_schema, table_name, ...rest }) => {
    const valuePath = [table_schema, table_name, column_name];
    // const value = get(result, valuePath, []);
    // value.push({...rest});
    set(result, valuePath, { ...rest });
  });

  const resultJSON = JSON.stringify(result, null, '  ');

  fs.writeFileSync(outForeignKeysPath, resultJSON);

  return true;
}

async function main() {
  const timerToPreventFreeze = setTimeout(() => {}, 999999);
  await genSchema();
  await genForeignKeys();
  clearTimeout(timerToPreventFreeze);
}

main().then(() => {
  process.exit();
});
