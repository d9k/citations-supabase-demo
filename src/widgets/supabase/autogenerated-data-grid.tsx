import { JsonView } from '/~/shared/ui/json-view.tsx';
import { WithQueryKeyUniqueSuffix } from '/~/shared/lib/react/query/key.ts';
import { useQuery } from '@tanstack/react-query';
import { useSupabase } from '/~/shared/providers/supabase/client.ts';
import {
  DbFieldInfo,
  DbTable,
} from '/~/shared/api/supabase/json-schema.types.ts';
import { DataGrid } from '/~/shared/ui/data-grid/index.tsx';
import { useMemo } from 'react';
import { Column } from '/~/shared/ui/data-grid/index.tsx';

//@deno-types="@types/lodash"
import { difference, intersection, keys, pick } from 'lodash';
import { useTransition } from 'react';

// @deno-types="@types/react-data-grid"
import { Row, textEditor } from 'react-data-grid';

import {
  FIELDS_AUTOGENERATED,
  FIELDS_IDS,
} from '/~/shared/api/supabase/const.ts';

import { notifications } from '@mantine/notifications';
import { json } from '/~/shared/lib/json.ts';

export type SupabaseAutogeneratedDataGridProps = {
  tableName: string;
  tableSchema: DbTable;
  firstColumnsNames?: string[];
} & WithQueryKeyUniqueSuffix;

export type ColumnAny = Column<Record<string, any>>;

// deno-lint-ignore ban-types
type R = {};

export const SupabaseAutogeneratedDataGrid = (
  {
    firstColumnsNames = ['id'],
    tableName,
    tableSchema,
    queryKeyUniqueSuffix,
  }: SupabaseAutogeneratedDataGridProps,
) => {
  console.debug(
    'SupabaseAutogeneratedDataGrid: queryKeyUniqueSuffix:',
    queryKeyUniqueSuffix,
  );

  const [isPending, startTransition] = useTransition();

  // const [isClient, setIsClient] = useState(false);

  // useEffect(() => {
  //   startTransition(() => {
  //     setIsClient(true);
  //   });
  // }, []);

  const supabase = useSupabase();

  const { data, isFetched, error } = useQuery({
    queryKey: ['SupabaseAutogeneratedDataGrid' + queryKeyUniqueSuffix],
    queryFn: () => supabase?.from(tableName).select('*'),
  });

  const rows = ((data || {}) as any).data || [];

  const columns: ColumnAny[] = useMemo(() => {
    const fieldsNames = keys(tableSchema);

    const fieldsNamesSorted = [
      ...intersection(fieldsNames, firstColumnsNames),
      ...difference(fieldsNames, firstColumnsNames),
    ];

    return fieldsNamesSorted.map((fieldName) => {
      // const _fieldInfo: DbFieldInfo = tableSchema[k]!;

      const column: ColumnAny = {
        editable: !FIELDS_AUTOGENERATED.includes(fieldName),
        frozen: FIELDS_IDS.includes(fieldName),
        key: fieldName,
        name: fieldName,
        renderEditCell: textEditor,
      };

      return column;
    });
  }, [tableSchema]);

  console.log('SupabaseAutogeneratedDataGrid: columns:', columns);

  const handleRowsChange = async (rows: R[]) => {
    const changedRowAllFields = rows[0];
    const id = (changedRowAllFields as any).id;
    console.log(changedRowAllFields);

    const fieldsNames = keys(changedRowAllFields);
    const filteredFieldsNames = difference(fieldsNames, FIELDS_AUTOGENERATED);
    const changedRow = pick(changedRowAllFields, filteredFieldsNames);
    // const changedRow = pick(changedRowAllFields, ['name']);

    notifications.show({
      title: 'Row changed',
      message: json(changedRow),
    });

    if (!id) {
      throw Error('id not set');
    }

    const result = await supabase?.from(tableName).update(changedRow).eq(
      'id',
      id,
    );

    console.log('SupabaseAutogeneratedDataGrid: handleRowsChange:', result);
  };

  return (
    <>
      {isFetched
        ? (
          <>
            {!isPending
              ? (
                <DataGrid
                  columns={columns}
                  rows={rows}
                  onRowsChange={handleRowsChange}
                />
              )
              : undefined}
            <JsonView data={{ ...data, rows, tableSchema }} />
          </>
        )
        : undefined}
    </>
  );
};
