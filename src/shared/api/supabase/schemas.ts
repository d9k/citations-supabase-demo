import { DbStructure } from '/~/shared/api/supabase/json-schema.types.ts';
import schemaData from '/~/shared/api/supabase/schema.generated.json' assert {
  type: 'json',
};
export const schemas = schemaData as unknown as DbStructure;

export const publicSchema = schemas.public;
