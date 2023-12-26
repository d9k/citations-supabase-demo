import { useQuery } from '@tanstack/react-query';
import { WithQueryKeyUniqueSuffix } from '/~/shared/lib/react/query/key.ts';
import { useSupabase } from '/~/shared/providers/supabase/index.ts';
import { useMemo } from 'react';

import {
  RlsEditForTableRecord,
} from '/~/shared/api/supabase/types/records.types.ts';

export type UseSupabaseQueryRlsInfoArgs = WithQueryKeyUniqueSuffix & {
  tableName: string;
  tableDataIds: number[];
};

export type RlsInfoById = { [id: number]: RlsEditForTableRecord };

export const HOOK_NAME = 'useSupabaseQueryRlsInfo';

//@deno-types="@types/lodash"
import { map } from 'lodash';

export const useSupabaseQueryRlsInfo = (
  { tableName, tableDataIds, queryKeyUniqueSuffix }:
    UseSupabaseQueryRlsInfoArgs,
) => {
  const supabase = useSupabase();

  const { data: resultRlsInfo, isFetched, error } = useQuery({
    queryKey: [`${HOOK_NAME}_editable_${queryKeyUniqueSuffix}`],
    enabled: tableDataIds.length > 0,
    queryFn: () =>
      supabase?.from('view_rls_edit_for_table').select().eq(
        'table_name',
        tableName,
      )
        .in('id', tableDataIds),
  });

  const rlsInfoArray: RlsEditForTableRecord[] = useMemo(
    () =>
      // TODO type
      (resultRlsInfo as any)?.data ||
      [],
    [resultRlsInfo],
  );

  const hasRlsInfo = rlsInfoArray.length > 0;

  const rlsInfoById: RlsInfoById = useMemo(() =>
    Object.fromEntries(
      rlsInfoArray.map((rlsInfo) => [rlsInfo.id, rlsInfo]),
    ), [rlsInfoArray]);

  return {
    hasRlsInfo,
    tableDataIds,
    rlsInfoArray,
    rlsInfoById,
    isFetchedRlsInfo: isFetched,
    errorRlsInfo: error,
    resultRlsInfo,
  };
};
