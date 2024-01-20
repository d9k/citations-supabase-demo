// @deno-types="@types/react-data-grid"
import { RenderCellProps } from 'react-data-grid';
import { booleanToStringValue } from './data-helpers.ts';

// deno-lint-ignore no-empty-interface
export interface CellBooleanProps<TRow, TSummaryRow = unknown>
  extends RenderCellProps<TRow, TSummaryRow> {}

/* See react-data-grid: src/editors/textEditor.tsx  */
export function CellBoolean<TRow, TSummaryRow>({
  column,
  row,
}: CellBooleanProps<TRow, TSummaryRow>) {
  const { key } = column;
  const value = row[key as keyof TRow] as unknown as boolean;

  return booleanToStringValue(value);
}
