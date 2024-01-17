import { useCallback } from 'react';
import { RecordAny } from '/~/shared/lib/ts/record-any.ts';
import { useSupabase } from '/~/shared/providers/supabase/index.ts';
import { FnKeyGetter } from '/~/shared/api/supabase/types/keys.types.ts';
import { json } from '/~/shared/lib/json.ts';
import { notifications } from '@mantine/notifications';
import { ERROR_SUPABASE_SHOW_DELAY } from '/~/widgets/supabase/autogenerated-data-grid/const.ts';
import { UseStateSetter } from '/~/shared/lib/react/hooks-types.ts';

export type UseOnRowDeleteArgs = {
  rowKeyGetter: FnKeyGetter;
  setRowToDelete: UseStateSetter<RecordAny | null>;
  tableName: string;
  onReloadRequired?: () => void;
};

export const HOOK_NAME = 'useOnRowDelete';

export const useOnRowDelete = ({
  onReloadRequired,
  rowKeyGetter,
  setRowToDelete,
  tableName,
}: UseOnRowDeleteArgs) => {
  const supabase = useSupabase();

  return useCallback(async (rowToDelete: RecordAny) => {
    const id = rowKeyGetter(rowToDelete);

    if (!id) {
      throw Error('id not set');
    }

    let errorText = '';
    let result = null;

    try {
      result = await supabase?.from(tableName).delete().eq('id', id);

      console.log(
        `${HOOK_NAME}: delete result:`,
        result,
        'deleting row:',
        rowToDelete,
      );
    } catch (e) {
      errorText = json(e);
    }

    errorText ||= result?.error ? json(result.error) : '';

    if (errorText) {
      notifications.show({
        color: 'red',
        title: `Error while row deletion`,
        message: <pre style={{ whiteSpace: 'pre-wrap' }}>{errorText}</pre>,
        autoClose: ERROR_SUPABASE_SHOW_DELAY,
      });
      console.error(errorText);
      return false;
    } else {
      notifications.show({
        message: `Successfully deleted`,
      });

      setRowToDelete(null);
      onReloadRequired?.();
      return true;
    }
  }, []);
};