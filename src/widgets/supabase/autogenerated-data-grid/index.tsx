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

import { Tables } from '/~/shared/api/supabase/types.generated.ts';

import { useColumns } from './hooks/columns.tsx';

import { ColumnAny } from '/~/shared/ui/data-grid/index.tsx';

type RlsEditForTable = Tables<'view_rls_edit_for_table'>;

//@deno-types="@types/lodash"
import {
  capitalize,
  difference,
  get,
  intersection,
  keys,
  map,
  pick,
} from 'lodash';

// @deno-types="@types/react-data-grid"
import { Row, textEditor } from 'react-data-grid';

import { RecordAny } from '/~/shared/lib/ts/record-any.ts';
import { arrayDiff } from '/~/shared/lib/diff.ts';

import {
  COLUMN_NAME_DELETABLE,
  COLUMN_NAME_EDITABLE,
  COLUMNS_AUTOGENERATED,
  COLUMNS_IDS,
} from '/~/shared/api/supabase/const.ts';

import { notifications } from '@mantine/notifications';
import { json } from '/~/shared/lib/json.ts';
import { useState } from 'react';

import { useColumnsNames } from '/~/shared/api/supabase/hooks/columns-names.ts';
import { Stack } from '@mantine/core';

export type SupabaseAutogeneratedDataGridProps = {
  allowInsert?: boolean;
  columnsNamesFirst?: string[];
  columnsNamesLast?: string[];
  onReloadRequired?: () => void;
  tableName: string;
  tableSchema: DbTable;
} & WithQueryKeyUniqueSuffix;

type RlsInfoById = { [id: number]: RlsEditForTable };

const NEW_RECORD_ID = '+';

const ERROR_SUPABASE_SHOW_DELAY = 8000;

const ELEMENT_NAME = 'SupabaseAutogeneratedDataGrid';

export const SupabaseAutogeneratedDataGrid = (
  {
    allowInsert = true,
    columnsNamesFirst = ['id', COLUMN_NAME_EDITABLE],
    columnsNamesLast = [],
    onReloadRequired,
    tableName,
    tableSchema,
    queryKeyUniqueSuffix,
  }: SupabaseAutogeneratedDataGridProps,
) => {
  const rowKeyGetter = (row: RecordAny | null) => row?.id;

  // deno-lint-ignore no-explicit-any
  const rowKeySetter = (row: RecordAny, values: any[]) => row.id = values[0];

  const createDummyRecord = (fieldsNamesEditable: string[]) => {
    const result = {
      /** To prevent warn "A component is changing an uncontrolled input to be controlled" */
      ...Object.fromEntries(fieldsNamesEditable.map((n) => [n, ''])),
    };

    rowKeySetter(result, [NEW_RECORD_ID]);

    return result;
  };

  console.debug(
    `${ELEMENT_NAME}: queryKeyUniqueSuffix:`,
    queryKeyUniqueSuffix,
  );
  const supabase = useSupabase();

  const { data: tableDataResult, isFetched, error } = useQuery({
    queryKey: [ELEMENT_NAME + '_' + queryKeyUniqueSuffix],
    queryFn: () => supabase?.from(tableName).select('*'),
  });

  // TODO Supabase type
  const tableData = ((tableDataResult || {}) as RecordAny).data;

  const ids = map(tableData, 'id') || [];

  const { data: editableDataResult } = useQuery({
    queryKey: [ELEMENT_NAME + '_editable_' + queryKeyUniqueSuffix],
    enabled: ids.length > 0,
    queryFn: () =>
      supabase?.from('view_rls_edit_for_table').select().eq(
        'table_name',
        tableName,
      )
        .in('id', ids),
  });

  // TODO type
  const rlsInfoArray: RlsEditForTable[] = (editableDataResult as any)?.data ||
    [];

  const hasRlsInfo = rlsInfoArray.length > 0;

  const rlsInfoById: RlsInfoById = useMemo(() =>
    Object.fromEntries(
      rlsInfoArray.map((rlsInfo) => [rlsInfo.id, rlsInfo]),
    ), [rlsInfoArray]);

  const [currentRow, setCurrentRow] = useState<RecordAny | null>(null);

  const {
    columnsNamesEditable,
    columnsNamesNullable,
    columnsNames,
    columnsNamesRequired,
  } = useColumnsNames({ hasRlsInfo, tableSchema });

  const rows = useMemo(() => {
    let result = [...(tableData || [])];

    if (hasRlsInfo) {
      result = result.map((r) => ({
        ...r,
        [COLUMN_NAME_EDITABLE]: rlsInfoById[r.id]?.editable ? 'yes' : '',
        [COLUMN_NAME_DELETABLE]: rlsInfoById[r.id]?.deletable ? 'yes' : '',
      }));
    }

    if (allowInsert) {
      result = [createDummyRecord(columnsNamesEditable), ...result];
    }

    const currentRowId = rowKeyGetter(currentRow);

    return result.map((r) =>
      (rowKeyGetter(r) === currentRowId) ? currentRow : r
    );
  }, [currentRow, rlsInfoById, hasRlsInfo, tableData]);

  const columns: ColumnAny[] = useColumns({
    columnsNamesAutogenerated: COLUMNS_AUTOGENERATED,
    columnsNamesIds: COLUMNS_IDS,
    columnsNamesFirst,
    columnsNamesLast,
    columnsNames,
    columnsNamesRequired,
  });

  console.log(`${ELEMENT_NAME}: columns:`, columns);

  const handleRowsChange = async (newRows: RecordAny[]) => {
    const changedRows = arrayDiff(newRows, rows);

    const changedRowAllFields = changedRows[0];

    setCurrentRow(changedRowAllFields);

    const id = rowKeyGetter(changedRowAllFields);

    console.log(
      `${ELEMENT_NAME}: handleRowsChange:`,
      changedRowAllFields,
    );

    const fieldsNames = keys(changedRowAllFields);
    const filteredFieldsNames = intersection(fieldsNames, columnsNamesEditable);
    const changedRow = pick(
      changedRowAllFields,
      filteredFieldsNames,
    );

    if (!id) {
      throw Error('id not set');
    }

    const insertMode = id === NEW_RECORD_ID;
    const insertModeText = insertMode ? 'insert' : 'update';
    const insertModeTextCapital = capitalize(insertModeText);

    let errorText = '';
    let result = null;

    columnsNamesNullable.forEach((n) => {
      if (changedRow[n] === '') {
        changedRow[n] = null;
      }
    });

    try {
      if (insertMode) {
        result = await supabase?.from(tableName).insert(changedRow);
      } else {
        result = await supabase?.from(tableName).update(changedRow).eq(
          'id',
          id,
        );
      }

      console.log(
        `${ELEMENT_NAME}: ${insertModeText} result:`,
        result,
        'changed row:',
        changedRow,
      );
    } catch (e) {
      errorText = json(e);
    }

    errorText ||= result?.error ? json(result.error) : '';

    if (errorText) {
      notifications.show({
        color: 'red',
        title: `Error while row ${insertModeText}`,
        message: <pre style={{ whiteSpace: 'pre-wrap' }}>{errorText}</pre>,
        autoClose: ERROR_SUPABASE_SHOW_DELAY,
      });
      console.error(errorText);
    } else {
      notifications.show({
        message: `${insertModeTextCapital} successfull`,
      });

      onReloadRequired?.();
      setCurrentRow(null);
    }
  };

  return (
    <>
      {isFetched
        ? (
          <Stack>
            <DataGrid
              columns={columns}
              rows={rows}
              onRowsChange={handleRowsChange}
            />
            <div>
              Double click on cell to edit. Edit cells of row with "+" id to add
              a new row.
            </div>
            <div>
              Cell edit{' '}
              <a
                href='https://github.com/adazzle/react-data-grid/issues/3408'
                target='_blank'
              >
                is not available on mobile phone
              </a>{' '}
              for the moment.
            </div>
            <JsonView
              data={{ tableDataResult, editableDataResult, rows, tableSchema }}
            />
          </Stack>
        )
        : undefined}
    </>
  );
};
