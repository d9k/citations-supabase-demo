import { Anchor } from '@mantine/core';

// import { FlexWra

// @deno-types="@types/react-data-grid"
import { RenderCellProps } from 'react-data-grid';

import { Group } from '@mantine/core';

export interface CellPublishedProps<TRow, TSummaryRow = unknown>
  extends RenderCellProps<TRow, TSummaryRow> {
  allowPublish?: boolean;
  onRowPublish?: (r: TRow) => void;
  onRowUnpublish?: (r: TRow) => void;
}

/* See react-data-grid: src/editors/textEditor.tsx  */
export function CellPublished<TRow, TSummaryRow>({
  allowPublish,
  column,
  onRowUnpublish,
  onRowPublish,
  row,
}: CellPublishedProps<TRow, TSummaryRow>) {
  const { key } = column;
  const value = row[key as keyof TRow] as unknown as boolean;

  const handlePublishClick = () => {
    onRowPublish?.(row);
    return false;
  };

  const handleUnpublishClick = () => {
    onRowUnpublish?.(row);
    return false;
  };

  if (typeof value == 'undefined') {
    return null;
  }

  return (
    <Group wrap='nowrap'>
      <span>{value ? 'yes' : 'no'}</span>

      {allowPublish
        ? (value
          ? (
            <Anchor key='unpublish' onClick={handleUnpublishClick}>
              unpublish
            </Anchor>
          )
          : <Anchor key='publish' onClick={handlePublishClick}>publish</Anchor>)
        : ''}
    </Group>
  );
}
