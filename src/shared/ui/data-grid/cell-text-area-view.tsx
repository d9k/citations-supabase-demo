import { ActionIcon, Button, Popover, Textarea } from '@mantine/core';

// @deno-types="@types/react-data-grid"
import { RenderCellProps } from 'react-data-grid';

import { SelectorItem } from './types.ts';
import { Group } from '@mantine/core';

// deno-lint-ignore no-empty-interface
export interface CellTextAreaProps<TRow, TSummaryRow = unknown>
  extends RenderCellProps<TRow, TSummaryRow> {}

/* See react-data-grid: src/editors/textEditor.tsx  */
export function CellTextAreaView<TRow, TSummaryRow>({
  column,
  row,
  onRowChange,
}: CellTextAreaProps<TRow, TSummaryRow>) {
  const { key } = column;
  const value = row[key as keyof TRow] as unknown as string;

  return (
    <Popover
      width={600}
      position='bottom-start'
      trapFocus
      offset={-30}
    >
      <Popover.Target>
        <span>{value}</span>
      </Popover.Target>
      <Popover.Dropdown>
        <Textarea
          value={value}
          onChange={(event) =>
            onRowChange({
              ...row,
              [key]: event.target.value,
            })}
          autosize
          minRows={2}
          maxRows={20}
          size='md'
        />
      </Popover.Dropdown>
    </Popover>
  );
}
