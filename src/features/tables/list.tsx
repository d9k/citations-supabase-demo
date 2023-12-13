import { DbSchema } from '/~/shared/api/supabase/json-schema.types.ts';
import schemaData from '/~/shared/api/supabase/schema.generated.json' assert {
  type: 'json',
};

// const schema = schemaData as DbSchema;

export const TablesList = () => {
  console.log('TablesList:', schemaData);

  return <></>;
};
