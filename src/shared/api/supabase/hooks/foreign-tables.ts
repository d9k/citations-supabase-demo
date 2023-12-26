import { useMemo } from 'react';
import { DbTable } from '/~/shared/api/supabase/json-schema.types.ts';

export type FieldToForeignTable = { [fieldName: string]: string };

export const useForeignTables = (tableSchema: DbTable) => {
  return useMemo(() => {
    const FN_NAME = 'tablesToLoadIdName';

    const foreignTablesNames = new Set<string>();
    const fieldToForeignTable: FieldToForeignTable = {};

    Object.values(tableSchema).forEach((i) => {
      const { fkInfo, name: fieldName } = i;

      if (!fkInfo) {
        return;
      }

      const { foreignTable, foreignField } = fkInfo;

      if (foreignField != 'id') {
        console.error(
          `${FN_NAME}: can't load id-name values for foreign key of field`,
          i,
        );
        return;
      }

      foreignTablesNames.add(foreignTable);

      fieldToForeignTable[fieldName] = foreignTable;
    });

    return { foreignTablesNames: [...foreignTablesNames], fieldToForeignTable };
  }, [tableSchema]);
};
