import { DbSchema } from '/~/shared/api/supabase/json-schema.types.ts';
import schemaData from '/~/shared/api/supabase/schema.generated.json' assert {
  type: 'json',
};
const schema = schemaData as unknown as DbSchema;

export const TablesList = () => {
  console.log('TablesList:', schema);
  const publicSchema = schema['public'];

  const list = Object.entries(publicSchema).map(([tableName, _tableSchema]) => {
    return <a key={tableName} href={`table/${tableName}`}>{tableName}</a>;
  });

  return <>{list}</>;
};
