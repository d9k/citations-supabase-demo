import { ActionIcon, Button, Popover, Textarea } from '@mantine/core';

// @deno-types="@types/react-data-grid"
import { RenderEditCellProps } from 'react-data-grid';

import { SelectorItem } from './types.ts';
import { Group } from '@mantine/core';

// deno-lint-ignore no-empty-interface
export interface CellTextAreaProps<TRow, TSummaryRow = unknown>
  extends RenderEditCellProps<TRow, TSummaryRow> {}

/* See react-data-grid: src/editors/textEditor.tsx  */
export function CellTextArea<TRow, TSummaryRow>({
  column,
  row,
  onRowChange,
}: CellTextAreaProps<TRow, TSummaryRow>) {
  const { key } = column;
  const value = row[key as keyof TRow] as unknown as string;

  return (
    <Popover
      width={600}
      opened
      position='bottom-start'
      trapFocus
      offset={-30}
    >
      <Popover.Target>
        <span>[Updating...]</span>
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
