// @deno-types="@types/react-data-grid"
import VendorDataGrid, {
  Column as VendorColumn,
  DataGridProps as VendorDataGridProps,
  Row as VendorRow,
} from 'react-data-grid';

import { useFela } from '/~/deps/react-fela/index.ts';
import { cssProps } from '/~/shared/lib/react/cssProps.ts';
import { EmptyRowsRenderer } from './empty-rows.tsx';

import { RecordAny } from '/~/shared/lib/ts/record-any.ts';

type Key = string | number;

export type Column<TRow, TSummaryRow = unknown> = VendorColumn<
  TRow,
  TSummaryRow
>;

export type ColumnAny = Column<RecordAny>;

export type DataGridProps<R, SR = unknown, K extends Key = Key> =
  VendorDataGridProps<R, SR, K>;

// function rowKeyGetter(row: any) {
//   return row.id;
// }

export const DataGrid = <R, SR = unknown, K extends Key = Key>(
  props: DataGridProps<R, SR, K>,
) => {
  const { css } = useFela();

  // TODO add idKey props
  const {
    // deno-lint-ignore no-explicit-any
    rowKeyGetter = (row) => (row as any).id,
    className,
  } = props;

  const felaCssClass = css({
    '--rdg-font-size': '14px',
    ...cssProps({
      blockSize: '100%',
      fontFamily: 'var(--mantine-font-family)',
      maxHeight: '100vh',
    }),
  });

  return (
    <VendorDataGrid
      {...props}
      className={`${felaCssClass} ${className}`}
      rowKeyGetter={rowKeyGetter}
      renderers={{ noRowsFallback: <EmptyRowsRenderer key='no-rows' /> }}
    />
  );
};
