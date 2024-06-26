import { useMemo } from 'react';

import { IdNameRecord } from '/~/shared/api/supabase/types/records.types.ts';
import { FieldToForeignTable } from '/~/shared/api/supabase/hooks/foreign-tables.ts';

import {
  DbFieldInfo,
  DbTable,
} from '/~/shared/api/supabase/json-schema.types.ts';

import {
  COLUMN_NAME_DELETABLE,
  COLUMN_NAME_EDITABLE,
  COLUMN_NAME_PUBLISHED,
} from '/~/shared/api/supabase/const.ts';

import {
  CellDeletable,
  CellDeletableProps,
} from '/~/shared/ui/data-grid/cell-deletable.tsx';

import {
  CellPublished,
  CellPublishedProps,
} from '/~/shared/ui/data-grid/cell-published.tsx';

import { CellTextArea } from '/~/shared/ui/data-grid/cell-text-area.tsx';
import { CellTextAreaView } from '/~/shared/ui/data-grid/cell-text-area-view.tsx';

import { RecordAny } from '/~/shared/lib/ts/record-any.ts';

//@deno-types="@types/lodash"
import { get, set } from 'lodash';

import { ColumnAny } from '/~/shared/ui/data-grid/index.tsx';

// @deno-types="@types/react-data-grid"
import { Row, textEditor } from 'react-data-grid';

//@deno-types="@types/lodash"
import { difference, intersection } from 'lodash';

import {
  ForeignIdToSelectorItem,
  SelectorItem,
} from '/~/shared/ui/data-grid/types.ts';
import { CellDropdownSelector } from '/~/shared/ui/data-grid/cell-dropdown-selector.tsx';
import { CellForeignId } from '/~/shared/ui/data-grid/cell-foreign-id.tsx';

import { CellBoolean } from '/~/shared/ui/data-grid/cell-boolean.tsx';
import { CellBooleanSelector } from '/~/shared/ui/data-grid/cell-boolean-selector.tsx';

export type ForeignTableToSelectorItem = {
  [foreignTableName: string]: SelectorItem[];
};

export type ForeignTableToIdToSelectorItem = {
  [foreignTableName: string]: ForeignIdToSelectorItem;
};

export const COLUMN_TEXT_LONG_WIDTH = 600;

export type UseColumnsArgs = {
  allowEdit?: boolean;
  allowPublish?: boolean;
  columnsNames: string[];
  columnsNamesAutogenerated: string[];
  columnsNamesFirst: string[];
  columnsNamesIds: string[];
  columnsNamesLast: string[];
  columnsNamesRequired: string[];
  columnsNamesTextLong?: string[];
  hasRlsInfo: boolean;
  foreignidsNames?: IdNameRecord[];
  fieldToForeignTable?: FieldToForeignTable;
  onRowActionDelete?: CellDeletableProps<RecordAny>['onRowDelete'];
  onRowActionPublish?: CellPublishedProps<RecordAny>['onRowPublish'];
  onRowActionUnpublish?: CellPublishedProps<RecordAny>['onRowUnpublish'];
  rowIsEditable?: (row: RecordAny) => boolean | null;
  tableSchema: DbTable;
};

export const useColumns = ({
  allowEdit,
  allowPublish,
  columnsNames,
  columnsNamesAutogenerated,
  columnsNamesFirst,
  columnsNamesIds,
  columnsNamesLast,
  columnsNamesRequired,
  columnsNamesTextLong = [],
  hasRlsInfo,
  fieldToForeignTable = {},
  foreignidsNames = [],
  onRowActionDelete,
  onRowActionPublish,
  onRowActionUnpublish,
  rowIsEditable,
  tableSchema,
}: UseColumnsArgs) => {
  const HOOK_NAME = 'useColumns';

  const columnsNamesActual = useMemo(() => {
    return [
      ...columnsNames,
      ...(
        hasRlsInfo ? [COLUMN_NAME_EDITABLE, COLUMN_NAME_DELETABLE] : []
      ),
    ];
  }, [columnsNames, hasRlsInfo]);

  const { foreignTableToSelectorItems, foreignTableToIdToSelectorItem } =
    useMemo(
      () => {
        const FN_NAME = 'selectorItemsByForeignTable';

        const foreignTableToSelectorItems: ForeignTableToSelectorItem = {};
        const foreignTableToIdToSelectorItem: ForeignTableToIdToSelectorItem =
          {};

        foreignidsNames.forEach((idName) => {
          const { id, short_name, table_name } = idName;

          if (!table_name) {
            console.error(
              `${HOOK_NAME}: ${FN_NAME}: no table_name in record `,
              idName,
            );
            return;
          }

          if (!id) {
            console.error(
              `${HOOK_NAME}: ${FN_NAME}: no id in record `,
              idName,
            );
            return;
          }

          const selectorItem = {
            label: `${id}. ${short_name}`,
            value: `${id}`,
          };

          foreignTableToSelectorItems[table_name] ||= [];
          foreignTableToSelectorItems[table_name].push(selectorItem);

          set(foreignTableToIdToSelectorItem, [table_name, id], selectorItem);
        });

        return { foreignTableToIdToSelectorItem, foreignTableToSelectorItems };
      },
      [foreignidsNames],
    );

  return useMemo(() => {
    const fieldsNamesFirst = intersection(
      columnsNamesFirst,
      columnsNamesActual,
    );
    const fieldsNamesLast = intersection(columnsNamesLast, columnsNamesActual);
    const fieldsNamesRest = difference(
      columnsNamesActual,
      columnsNamesFirst,
      columnsNamesLast,
    );

    const fieldsNamesRestSorted = [
      ...intersection(fieldsNamesRest, columnsNamesRequired).sort(),
      ...difference(fieldsNamesRest, columnsNamesRequired).sort(),
    ];

    const fieldsNamesSorted = [
      ...fieldsNamesFirst,
      ...fieldsNamesRestSorted,
      ...fieldsNamesLast,
    ];

    const columns = fieldsNamesSorted.map((fieldName) => {
      const required = columnsNamesRequired.includes(fieldName);

      const foreignTable = fieldToForeignTable[fieldName];

      let selectorItems: SelectorItem[] = [];
      let idToSelectorItem: ForeignIdToSelectorItem;

      if (foreignTable) {
        selectorItems = foreignTableToSelectorItems[foreignTable] || [];
        idToSelectorItem = foreignTableToIdToSelectorItem[foreignTable];
      }

      const fieldInfo: DbFieldInfo = tableSchema[fieldName];

      const editable = !columnsNamesAutogenerated.includes(fieldName);

      const column: ColumnAny = {
        frozen: columnsNamesIds.includes(fieldName),
        key: fieldName,
        name: `${fieldName}${required ? ' *' : ''}`,

        ...(foreignTable
          ? {
            renderCell: (renderProps) => (
              <CellForeignId
                {...renderProps}
                key={`${fieldName}_cell_foreign_id`}
                data={idToSelectorItem}
              />
            ),
          }
          : {}),

        ...(fieldName === COLUMN_NAME_DELETABLE
          ? {
            renderCell: (renderProps) => (
              <CellDeletable
                {...renderProps}
                key={`${fieldName}_cell_deletable`}
                onRowDelete={onRowActionDelete}
              />
            ),
          }
          : {}),

        ...(editable && allowEdit
          ? {
            renderEditCell: (
              selectorItems.length
                ? (renderProps) => (
                  <CellDropdownSelector
                    key={`${fieldName}_selector`}
                    data={selectorItems}
                    {...renderProps}
                  />
                )
                : textEditor
            ),
          }
          : {}),

        ...(fieldInfo?.type === 'boolean'
          ? {
            renderCell: (renderProps) => <CellBoolean {...renderProps} />,
            renderEditCell: (renderProps) => (
              <CellBooleanSelector {...renderProps} />
            ),
          }
          : {}),

        editable: (row: RecordAny) => {
          if (rowIsEditable?.(row) === false) {
            return false;
          }

          return editable;
        },

        ...(fieldName === COLUMN_NAME_PUBLISHED
          ? {
            renderCell: (renderProps) => (
              <CellPublished
                {...renderProps}
                allowPublish={allowPublish}
                key={`${fieldName}_cell_published`}
                onRowPublish={onRowActionPublish}
                onRowUnpublish={onRowActionUnpublish}
              />
            ),
            renderEditCell: undefined,
          }
          : {}),

        ...(columnsNamesTextLong.includes(fieldName)
          ? {
            width: COLUMN_TEXT_LONG_WIDTH,
            renderEditCell: (renderProps) => (
              <CellTextArea
                key={`${fieldName}_input`}
                {...renderProps}
              />
            ),
            renderCell: (renderProps) => (
              <CellTextAreaView
                key={`${fieldName}_input`}
                {...renderProps}
              />
            ),
          }
          : {}),
      };

      return column;
    });

    return {
      columns,
      columnsNamesActual,
      fieldsNamesFirst,
      fieldsNamesLast,
      fieldsNamesRestSorted,
      fieldsNamesSorted,
      foreignTableToSelectorItems,
    };
  }, [
    columnsNamesActual,
    columnsNamesFirst,
    columnsNamesLast,
    columnsNames,
    columnsNamesRequired,
    foreignTableToSelectorItems,
    foreignTableToIdToSelectorItem,
    fieldToForeignTable,
  ]);
};
