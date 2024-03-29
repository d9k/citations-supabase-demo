import { DbTable } from '/~/shared/api/supabase/json-schema.types.ts';
import { useMemo } from 'react';

import {
  COLUMN_NAME_PUBLISHED,
  COLUMNS_AUTOGENERATED,
  COLUMNS_TO_ORDER_BY_DEFAULT,
} from '/~/shared/api/supabase/const.ts';
import { DbFieldInfo } from '/~/shared/api/supabase/json-schema.types.ts';

//@deno-types="@types/lodash"
import { difference, intersection, keys } from 'lodash';

export type UseFieldsNamesArgs = {
  allowPublish?: boolean;
  tableSchema: DbTable;
};

export const useColumnsNames = (
  { allowPublish = false, tableSchema }: UseFieldsNamesArgs,
) => {
  const columnsNamesOriginal = useMemo(() => keys(tableSchema), [tableSchema]);

  const columnsNames = useMemo(() => {
    const result = [...columnsNamesOriginal];
    if (allowPublish) {
      result.push(COLUMN_NAME_PUBLISHED);
    }
    return result;
  }, [columnsNamesOriginal]);

  const orderByColumnDefault = useMemo(() =>
    intersection(
      COLUMNS_TO_ORDER_BY_DEFAULT,
      columnsNames,
    )[0], [columnsNames]);

  const columnsNamesEditable = useMemo(() =>
    difference(
      columnsNames,
      COLUMNS_AUTOGENERATED,
    ), [columnsNames]);

  const columnsNamesNullable = useMemo(() =>
    columnsNamesEditable
      .filter((n) => {
        const fieldInfo: DbFieldInfo = tableSchema[n];
        return fieldInfo.nullable;
      }), [columnsNamesEditable]);

  const columnsNamesRequired = useMemo(() =>
    difference(
      columnsNamesEditable,
      columnsNamesNullable,
    ), [columnsNamesEditable, columnsNamesNullable]);

  return {
    columnsNamesOriginal,
    columnsNames,
    columnsNamesEditable,
    columnsNamesNullable,
    columnsNamesRequired,
    orderByColumnDefault,
  };
};
