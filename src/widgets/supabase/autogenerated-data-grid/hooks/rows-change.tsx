import { useCallback } from 'react';
import { RecordAny } from '/~/shared/lib/ts/record-any.ts';
import { useSupabase } from '/~/shared/providers/supabase/index.ts';
import { FnKeyGetter } from '/~/shared/api/supabase/types/keys.types.ts';
import { json } from '/~/shared/lib/json.ts';
import { notifications } from '@mantine/notifications';
import { UseStateSetter } from '/~/shared/lib/react/hooks-types.ts';
import { arrayDiff } from '/~/shared/lib/diff.ts';

import { ERROR_SUPABASE_SHOW_DELAY, NEW_RECORD_ID } from '../const.ts';

//@deno-types="@types/lodash"
import { capitalize, intersection, keys, map, pick } from 'lodash';

export type UseOnRowsChangeArgs = {
  columnsNamesNullable: string[];
  columnsNamesEditable: string[];
  rowKeyGetter: FnKeyGetter;
  rows: RecordAny[];
  setCurrentRow: UseStateSetter<RecordAny | null>;
  tableName: string;
  onReloadRequired?: () => void;
};

export const HOOK_NAME = 'useOnRowChange';

export const useOnRowsChange = ({
  columnsNamesEditable,
  columnsNamesNullable,
  onReloadRequired,
  rowKeyGetter,
  rows,
  setCurrentRow,
  tableName,
}: UseOnRowsChangeArgs) => {
  const supabase = useSupabase();

  return useCallback(async (newRows: RecordAny[]) => {
    const changedRows = arrayDiff(newRows, rows);

    const changedRowAllFields = changedRows[0];

    setCurrentRow(changedRowAllFields);

    const id = rowKeyGetter(changedRowAllFields);

    console.log(
      `${HOOK_NAME}: handleRowsChange:`,
      changedRowAllFields,
    );

    const fieldsNames = keys(changedRowAllFields);
    const filteredFieldsNames = intersection(fieldsNames, columnsNamesEditable);
    const changedRow = pick(
      changedRowAllFields,
      filteredFieldsNames,
    );

    if (!id) {
      throw Error('id not set');
    }

    const insertMode = id === NEW_RECORD_ID;
    const insertModeText = insertMode ? 'insert' : 'update';
    const insertModeTextCapital = capitalize(insertModeText);

    let errorText = '';
    let result = null;

    columnsNamesNullable.forEach((n) => {
      if (changedRow[n] === '') {
        changedRow[n] = null;
      }
    });

    try {
      if (insertMode) {
        result = await supabase?.from(tableName).insert(changedRow);
      } else {
        result = await supabase?.from(tableName).update(changedRow).eq(
          'id',
          id,
        );
      }

      console.log(
        `${HOOK_NAME}: ${insertModeText} result:`,
        result,
        'changed row:',
        changedRow,
      );
    } catch (e) {
      errorText = json(e);
    }

    errorText ||= result?.error ? json(result.error) : '';

    if (errorText) {
      notifications.show({
        color: 'red',
        title: `Error while row ${insertModeText}`,
        message: <pre style={{ whiteSpace: 'pre-wrap' }}>{errorText}</pre>,
        autoClose: ERROR_SUPABASE_SHOW_DELAY,
      });
      console.error(errorText);
    } else {
      notifications.show({
        message: `${insertModeTextCapital} successfull`,
      });

      onReloadRequired?.();
      setCurrentRow(null);
    }
  }, []);
};
