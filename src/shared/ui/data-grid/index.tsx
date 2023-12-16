// @deno-types="@types/react-data-grid"
import VendorDataGrid, {
  Column as VendorColumn,
  DataGridProps as VendorDataGridProps,
} from 'react-data-grid';

import { useFela } from '/~/deps/react-fela/index.ts';
import { cssProps } from '/~/shared/lib/react/cssProps.ts';

type Key = string | number;

export type Column<TRow, TSummaryRow = unknown> = VendorColumn<
  TRow,
  TSummaryRow
>;

export type DataGridProps<R, SR = unknown, K extends Key = Key> = Pick<
  VendorDataGridProps<R, SR, K>,
  'rows' | 'columns'
>;

export const DataGrid = <R, SR = unknown, K extends Key = Key>(
  props: DataGridProps<R, SR, K>,
) => {
  const { css } = useFela();

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
    />
  );
};
