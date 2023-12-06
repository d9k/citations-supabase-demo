import * as fs from 'fs';
import { config as dotEnvConfig } from 'dotenv';
import { iterateNestedObj } from '/~/shared/lib/struct/tree.ts';
import { envValueRequire } from '/~/shared/lib/node/env';
import get from 'lodash/get';
import { DbFieldInfo } from '/~/shared/api/supabase/json-schema.types';
import { json } from '/~/shared/lib/json';

dotEnvConfig();

const descriptionsPath = envValueRequire('SUPABASE_DESCRIPTION_PATH');
const supabaseSchemaJsonPath = envValueRequire(
  'SUPABASE_SCHEMA_JSON_PATH',
);

const descriptions = JSON.parse(fs.readFileSync(descriptionsPath).toString());
const schema = JSON.parse(
  fs.readFileSync(supabaseSchemaJsonPath).toString(),
);

iterateNestedObj({
  obj: descriptions,
  callback: ({ path, value }) => {
    // console.log({ path, value });
    const fieldInfo: DbFieldInfo | undefined = get(schema, path);

    if (!fieldInfo) {
      console.error(
        'Error: field with path',
        path,
        `not found! Description "${value}" will be lost`,
      );
      return;
    }

    fieldInfo.description = value;
  },
  leafsOnly: true,
});

console.log(`Saving changes to "${supabaseSchemaJsonPath}"`);

fs.writeFileSync(supabaseSchemaJsonPath, json(schema), 'utf8');
