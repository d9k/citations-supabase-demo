import { useQuery } from '@tanstack/react-query';
import { WithQueryKeyUniqueSuffix } from '/~/shared/lib/react/query/key.ts';
import { RecordAny } from '/~/shared/lib/ts/record-any.ts';
import { useSupabase } from '/~/shared/providers/supabase/index.ts';
import { useMemo } from 'react';

export type UseSupabaseQueryTableDataArgs = WithQueryKeyUniqueSuffix & {
  orderByColumn?: string;
  tableName: string;
};

export const HOOK_NAME = 'useSupabaseQueryTableData';

//@deno-types="@types/lodash"
import { map } from 'lodash';

export const useSupabaseQueryTableData = (
  { orderByColumn, tableName, queryKeyUniqueSuffix }:
    UseSupabaseQueryTableDataArgs,
) => {
  const supabase = useSupabase();

  const { data: resultTableData, isFetched, error } = useQuery({
    queryKey: [`${HOOK_NAME}_${queryKeyUniqueSuffix}`],
    queryFn: () => {
      const request = supabase?.from(tableName).select('*');
      if (orderByColumn) {
        request?.order(orderByColumn);
      }
      return request;
    },
  });

  // TODO Supabase type
  const tableData = useMemo(() => ((resultTableData || {}) as RecordAny).data, [
    resultTableData,
  ]);

  const tableDataIds = useMemo(() => map(tableData, 'id') || [], [tableData]);

  return {
    tableDataIds,
    tableData,
    resultTableData,
    isFetchedTableData: isFetched,
    errorTableData: error,
  };
};
