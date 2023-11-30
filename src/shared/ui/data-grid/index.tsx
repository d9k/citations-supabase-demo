import VendorDataGrid, {
  Column as VendorColumn,
  DataGridProps as VendorDataGridProps,
} from 'react-data-grid';

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
  return <VendorDataGrid {...props} />;
};
