import { useSupabaseUser } from './user.ts';

// deno-lint-ignore no-explicit-any
export const useSupabaseClaim = (claimName: string): any => {
  const supabaseUser = useSupabaseUser();
  return supabaseUser?.app_metadata?.[claimName];
};
