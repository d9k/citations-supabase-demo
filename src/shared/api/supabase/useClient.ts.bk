import useEnv from 'ultra/hooks/use-env.js';
import { createClient } from '@supabase/supabase-js';
// import { useMemo } from 'react';

import { memoize } from 'lodash/memoize';

export type UseSupabaseClientArgs = {
  anonKey?: string;
  supabaseUrl?: string;
};

export const createClientMemoized: typeof createClient = memoize(createClient);

// TODO env variables must not be at /shared FSD layer?
export const useSupabaseClient = (
  { anonKey, supabaseUrl }: UseSupabaseClientArgs,
) => {
  const supabaseUrlCurrent = supabaseUrl ||
    useEnv('ULTRA_PUBLIC_SUPABASE_URL')!;
  const anonKeyCurrent = anonKey || useEnv(
    'ULTRA_PUBLIC_SUPABASE_ANON_KEY',
  )!;

  // console.log({
  //   supabaseUrlCurrent,
  //   anonKeyCurrent,
  // });

  return createClientMemoized(supabaseUrlCurrent, anonKeyCurrent);
};
