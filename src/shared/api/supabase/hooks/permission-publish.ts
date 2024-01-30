import { useQuery } from '@tanstack/react-query';
import { WithQueryKeyUniqueSuffix } from '/~/shared/lib/react/query/key.ts';
import { useSupabase } from '/~/shared/providers/supabase/index.ts';

export type UseSupabaseQueryIdName = WithQueryKeyUniqueSuffix;

export const HOOK_NAME = 'useSupabasePermissionPublish';

export const useSupabasePermissionPublish = (
  { queryKeyUniqueSuffix }: UseSupabaseQueryIdName,
) => {
  const supabase = useSupabase();

  const { data, isFetched, error } = useQuery({
    queryKey: [HOOK_NAME, 'permission_publish', queryKeyUniqueSuffix],
    // enabled: foreignTablesNames.length > 0,
    queryFn: () => supabase?.rpc('permission_publish_get'),
  });

  return {
    resultPermissionPublish: !!((data as any)?.data),
    errorCheckPermissionPublish: error,
    isFetchedPermissionPublish: isFetched,
  };
};
