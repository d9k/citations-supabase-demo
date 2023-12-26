import { ComboboxItem, Select } from '@mantine/core';

// @deno-types="@types/react-data-grid"
import { RenderCellProps } from 'react-data-grid';

import { ForeignIdToSelectorItem, SelectorItem } from './types.ts';

export interface CellForeignIdProps<TRow, TSummaryRow = unknown>
  extends RenderCellProps<TRow, TSummaryRow> {
  data?: ForeignIdToSelectorItem;
}

/* See react-data-grid: src/editors/textEditor.tsx  */
export function CellForeignId<TRow, TSummaryRow>({
  column,
  data,
  row,
}: CellForeignIdProps<TRow, TSummaryRow>) {
  const { key } = column;
  const value = row[key as keyof TRow] as unknown as string;

  let text = value;

  if (data) {
    const si: SelectorItem = data[value];
    text = si?.label || text;
  }

  return text;
}
