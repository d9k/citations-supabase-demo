import { useMemo } from 'react';

import { IdNameRecord } from '/~/shared/api/supabase/records.types.ts';
import { FieldToForeignTable } from '/~/shared/api/supabase/hooks/foreign-tables.ts';

import { COLUMN_NAME_DELETABLE } from '/~/shared/api/supabase/const.ts';

import {
  CellDeletable,
  CellDeletableProps,
} from '/~/shared/ui/data-grid/cell-deletable.tsx';

import { RecordAny } from '/~/shared/lib/ts/record-any.ts';

export type UseColumnsArgs = {
  columnsNames: string[];
  columnsNamesAutogenerated: string[];
  columnsNamesFirst: string[];
  columnsNamesIds: string[];
  columnsNamesLast: string[];
  columnsNamesRequired: string[];
  foreignidsNames?: IdNameRecord[];
  fieldToForeignTable?: FieldToForeignTable;
  onRowDelete?: CellDeletableProps<RecordAny>['onRowDelete'];
};

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

export type ForeignTableToSelectorItem = {
  [foreignTableName: string]: SelectorItem[];
};

export type ForeignTableToIdToSelectorItem = {
  [foreignTableName: string]: ForeignIdToSelectorItem;
};

export const useColumns = ({
  columnsNames,
  columnsNamesAutogenerated,
  columnsNamesFirst,
  columnsNamesIds,
  columnsNamesLast,
  columnsNamesRequired,
  fieldToForeignTable = {},
  foreignidsNames = [],
  onRowDelete,
}: UseColumnsArgs) => {
  const HOOK_NAME = 'useColumns';

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
      columnsNames,
    );
    const fieldsNamesLast = intersection(columnsNamesLast, columnsNames);
    const fieldsNamesRest = difference(
      columnsNames,
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

      const editable = !columnsNamesAutogenerated.includes(fieldName);

      const column: ColumnAny = {
        editable,
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
                key={`${fieldName}_cell_foreign_id`}
                onRowDelete={onRowDelete}
              />
            ),
          }
          : {}),
        ...(editable
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
      };

      return column;
    });

    return {
      columns,
      fieldsNamesFirst,
      fieldsNamesLast,
      fieldsNamesRestSorted,
      fieldsNamesSorted,
      foreignTableToSelectorItems,
    };
  }, [
    columnsNamesFirst,
    columnsNamesLast,
    columnsNames,
    columnsNamesRequired,
    foreignTableToSelectorItems,
    foreignTableToIdToSelectorItem,
    fieldToForeignTable,
  ]);
};
