// @deno-types="@types/react-data-grid"
import VendorDataGrid, {
  Column as VendorColumn,
  DataGridProps as VendorDataGridProps,
  Row as VendorRow,
} from 'react-data-grid';

import { useFela } from '/~/deps/react-fela/index.ts';
import { cssProps } from '/~/shared/lib/react/cssProps.ts';
import { EmptyRowsRenderer } from './empty-rows.tsx';
import { useCallback } from 'react';

type Key = string | number;

export type Column<TRow, TSummaryRow = unknown> = VendorColumn<
  TRow,
  TSummaryRow
>;

export type DataGridProps<R, SR = unknown, K extends Key = Key> =
  VendorDataGridProps<R, SR, K>;

const handleRowsChange = (a: any) => {
  console.log(a);
};

// function rowKeyGetter(row: any) {
//   return row.id;
// }

export const DataGrid = <R, SR = unknown, K extends Key = Key>(
  props: DataGridProps<R, SR, K>,
) => {
  const { css } = useFela();

  // TODO add idKey props
  // deno-lint-ignore no-explicit-any
  const { rowKeyGetter = (row) => (row as any).id } = props;

  return (
    <VendorDataGrid
      {...props}
      className={css({
        '--rdg-font-size': '14px',
        ...cssProps({
          blockSize: '100%',
          fontFamily: 'var(--mantine-font-family)',
        }),
      })}
      onRowsChange={handleRowsChange}
      rowKeyGetter={rowKeyGetter}
      renderers={{ noRowsFallback: <EmptyRowsRenderer key='no-rows' /> }}
    />
  );
};
