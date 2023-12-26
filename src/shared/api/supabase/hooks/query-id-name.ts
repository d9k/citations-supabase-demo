import { useQuery } from '@tanstack/react-query';
import { WithQueryKeyUniqueSuffix } from '/~/shared/lib/react/query/key.ts';
import { RecordAny } from '/~/shared/lib/ts/record-any.ts';
import { useSupabase } from '/~/shared/providers/supabase/index.ts';
import { useMemo } from 'react';

import { IdNameRecord } from '/~/shared/api/supabase/types/records.types.ts';

export type UseSupabaseQueryIdName = WithQueryKeyUniqueSuffix & {
  foreignTablesNames: string[];
};

export const HOOK_NAME = 'UseSupabaseQueryIdName';

//@deno-types="@types/lodash"
import { map } from 'lodash';

export const useSupabaseQueryIdName = (
  { foreignTablesNames, queryKeyUniqueSuffix }: UseSupabaseQueryIdName,
) => {
  const supabase = useSupabase();

  const { data: resultForeignidsNames, isFetched, error } = useQuery({
    queryKey: [HOOK_NAME, 'ids_names', queryKeyUniqueSuffix],
    enabled: foreignTablesNames.length > 0,
    queryFn: () =>
      supabase?.from('view_id_name').select().in(
        'table_name',
        foreignTablesNames,
      ),
  });

  const foreignidsNames: IdNameRecord[] = useMemo(
    () => (resultForeignidsNames as any)?.data || [],
    [resultForeignidsNames],
  );

  return {
    foreignidsNames,
    errorForeignidsNames: error,
    resultForeignidsNames,
    isFetchedForeignIdsNames: isFetched,
  };
};
