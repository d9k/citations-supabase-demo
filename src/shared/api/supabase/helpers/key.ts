import {
  FnKeyGetter,
  FnKeySetter,
} from '/~/shared/api/supabase/types/keys.types.ts';

export const DEFAULT_KEY_GETTER: FnKeyGetter = (row) => row?.id;
export const DEFAULT_KEY_SETTER: FnKeySetter = (row, value) => row.id = value;
