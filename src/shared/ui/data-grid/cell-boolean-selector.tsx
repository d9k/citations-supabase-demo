import { Select } from '@mantine/core';

// @deno-types="@types/react-data-grid"
import { RenderEditCellProps } from 'react-data-grid';

import { SelectorItem } from './types.ts';

// deno-lint-ignore no-empty-interface
export interface CellBooleanSelectorProps<TRow, TSummaryRow = unknown>
  extends RenderEditCellProps<TRow, TSummaryRow> {}

import {
  booleanToStringValue,
  stringValueToBoolean,
  VALUE_FALSE,
  VALUE_TRUE,
  VALUE_UNDEFINED,
} from './data-helpers.ts';

/* See react-data-grid: src/editors/textEditor.tsx  */
export function CellBooleanSelector<TRow, TSummaryRow>({
  column,
  row,
  onRowChange,
}: CellBooleanSelectorProps<TRow, TSummaryRow>) {
  const data: SelectorItem[] = [
    {
      label: '',
      value: VALUE_UNDEFINED,
    },
    {
      label: 'yes',
      value: VALUE_TRUE,
    },
    {
      label: 'no',
      value: VALUE_FALSE,
    },
  ];

  const { key } = column;
  const value = row[key as keyof TRow] as unknown as boolean;
  const stringValue = booleanToStringValue(value);

  return (
    <Select
      data={data}
      value={stringValue}
      onChange={(newStringValue) => {
        const newBooleanValue = stringValueToBoolean(`${newStringValue}`);

        const newRow = {
          ...row,
          [key]: newBooleanValue,
        };

        onRowChange(newRow);
      }}
    />
  );
}
