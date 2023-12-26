import { Anchor } from '@mantine/core';

// @deno-types="@types/react-data-grid"
import { RenderCellProps } from 'react-data-grid';

export interface CellDeletableProps<TRow, TSummaryRow = unknown>
  extends RenderCellProps<TRow, TSummaryRow> {
  onRowDelete?: (r: TRow) => void;
}

/* See react-data-grid: src/editors/textEditor.tsx  */
export function CellDeletable<TRow, TSummaryRow>({
  column,
  onRowDelete,
  row,
}: CellDeletableProps<TRow, TSummaryRow>) {
  const { key } = column;
  const value = row[key as keyof TRow] as unknown as boolean;

  const handleClick = () => {
    onRowDelete?.(row);
    return false;
  };

  return value ? <Anchor onClick={handleClick}>delete</Anchor> : '';
}
