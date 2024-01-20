import { JsonView } from '/~/shared/ui/json-view.tsx';
import { WithQueryKeyUniqueSuffix } from '/~/shared/lib/react/query/key.ts';
import { DbTable } from '/~/shared/api/supabase/json-schema.types.ts';
import { DataGrid } from '/~/shared/ui/data-grid/index.tsx';
import { useMemo } from 'react';

import { useForeignTables } from '/~/shared/api/supabase/hooks/foreign-tables.ts';

import { useColumns } from './hooks/columns.tsx';
import { useOnRowDelete } from './hooks/row-delete.tsx';
import { useOnRowPublish } from './hooks/row-publish.tsx';
import { useOnRowUnpublish } from './hooks/row-unpublish.tsx';
import { useOnRowsChange } from './hooks/rows-change.tsx';

import { RecordAny } from '/~/shared/lib/ts/record-any.ts';

import {
  COLUMN_NAME_DELETABLE,
  COLUMN_NAME_EDITABLE,
  COLUMN_NAME_PUBLISHED,
  COLUMNS_AUTOGENERATED,
  COLUMNS_IDS,
} from '/~/shared/api/supabase/const.ts';

import {
  DEFAULT_KEY_GETTER,
  DEFAULT_KEY_SETTER,
} from '/~/shared/api/supabase/helpers/key.ts';

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

import { useCreateDummyRecord } from './hooks/create-dummy-record.ts';

import { useSupabaseQueryRlsInfo } from '/~/shared/api/supabase/hooks/query-rls-info.ts';
import { useSupabaseQueryTableData } from '/~/shared/api/supabase/hooks/query-table-data.ts';
import { useSupabaseQueryIdName } from '/~/shared/api/supabase/hooks/query-id-name.ts';
import { useDisclosure } from '@mantine/hooks';
import { useCallback } from 'react';

import { ModalDeleteRow } from './modal-delete-row.tsx';

import { useSupabasePermissionPublish } from '/~/shared/api/supabase/hooks/permission-publish.ts';

export const ELEMENT_NAME = 'SupabaseAutogeneratedDataGrid';

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
  const rowKeyGetter = DEFAULT_KEY_GETTER;
  const rowKeySetter = DEFAULT_KEY_SETTER;

  const [
    modalDeleteItemOpened,
    { open: modalDeleteItemOpen, close: modalDeleteItemClose },
  ] = useDisclosure();

  const { createDummyRecord } = useCreateDummyRecord({
    rowKeySetter,
    tableSchema,
  });

  // console.debug(
  //   `${ELEMENT_NAME}: queryKeyUniqueSuffix:`,
  //   queryKeyUniqueSuffix,
  // );

  const { resultPermissionPublish } = useSupabasePermissionPublish({
    queryKeyUniqueSuffix,
  });

  const allowPublish = !!resultPermissionPublish;

  const {
    columnsNamesEditable,
    columnsNamesNullable,
    columnsNames,
    columnsNamesRequired,
    orderByColumnDefault,
  } = useColumnsNames({ allowPublish, tableSchema });

  const { isFetchedTableData, resultTableData, tableData, tableDataIds } =
    useSupabaseQueryTableData({
      orderByColumn: orderByColumnDefault,
      tableName,
      queryKeyUniqueSuffix,
    });

  /** current row which is edited */
  const [currentRow, setCurrentRow] = useState<RecordAny | null>(null);
  const [rowToDelete, setRowToDelete] = useState<RecordAny | null>(null);

  const {
    hasRlsInfo,
    rlsInfoById,
    resultRlsInfo,
  } = useSupabaseQueryRlsInfo({
    queryKeyUniqueSuffix,
    tableDataIds,
    tableName,
  });

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

  const { foreignTablesNames, fieldToForeignTable } = useForeignTables(
    tableSchema,
  );

  const { foreignidsNames } = useSupabaseQueryIdName({
    foreignTablesNames,
    queryKeyUniqueSuffix,
  });

  const onRowDelete = useOnRowDelete({
    onReloadRequired,
    rowKeyGetter,
    setRowToDelete,
    tableName,
  });

  const onRowActionPublish = useOnRowPublish({
    onReloadRequired,
    rowKeyGetter,
    tableName,
  });

  const onRowActionUnpublish = useOnRowUnpublish({
    onReloadRequired,
    rowKeyGetter,
    tableName,
  });

  const onRowActionDelete = useCallback((row: RecordAny) => {
    setRowToDelete(row);
    modalDeleteItemOpen();
  }, [modalDeleteItemOpen, setRowToDelete]);

  const { columns, foreignTableToSelectorItems } = useColumns({
    allowPublish,
    columnsNamesAutogenerated: COLUMNS_AUTOGENERATED,
    columnsNamesIds: COLUMNS_IDS,
    columnsNamesFirst,
    columnsNamesLast,
    columnsNames,
    columnsNamesRequired,
    hasRlsInfo,
    foreignidsNames,
    fieldToForeignTable,
    onRowActionDelete,
    onRowActionPublish,
    onRowActionUnpublish,
    tableSchema,
  });

  console.log(`${ELEMENT_NAME}: columns:`, columns);

  const onRowsChange = useOnRowsChange({
    columnsNamesEditable,
    columnsNamesNullable,
    onReloadRequired,
    rowKeyGetter,
    rows,
    setCurrentRow,

    tableName,
  });

  return (
    <>
      {isFetchedTableData
        ? (
          <Stack>
            <ModalDeleteRow
              opened={modalDeleteItemOpened}
              onClose={modalDeleteItemClose}
              rowKeyGetter={rowKeyGetter}
              rowToDelete={rowToDelete}
              onRowDelete={onRowDelete}
            />
            <DataGrid
              columns={columns}
              rows={rows}
              onRowsChange={onRowsChange}
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
              data={{
                allowPublish,
                orderByColumnDefault,
                resultTableData,
                resultRlsInfo,
                rows,
                tableSchema,
                foreignidsNames,
                foreignTableToSelectorItems,
              }}
            />
          </Stack>
        )
        : undefined}
    </>
  );
};
