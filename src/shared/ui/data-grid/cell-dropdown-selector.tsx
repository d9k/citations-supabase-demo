import { Select } from '@mantine/core';

// @deno-types="@types/react-data-grid"
import { RenderEditCellProps } from 'react-data-grid';

import { SelectorItem } from './types.ts';

export interface CellDropdownSelectorProps<TRow, TSummaryRow = unknown>
  extends RenderEditCellProps<TRow, TSummaryRow> {
  data: SelectorItem[];
}

/* See react-data-grid: src/editors/textEditor.tsx  */
export function CellDropdownSelector<TRow, TSummaryRow>({
  column,
  data,
  row,
  onRowChange,
}: CellDropdownSelectorProps<TRow, TSummaryRow>) {
  const { key } = column;
  const value = row[key as keyof TRow] as unknown as string;

  return (
    <Select
      data={data}
      value={value}
      onChange={(newValue) =>
        onRowChange({
          ...row,
          [key]: newValue,
        })}
    />
  );
}
