import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';
import { createBrowserClient } from '@supabase/ssr';
import { createClient } from '@supabase/supabase-js';
import {
  SupabaseCreateClientResult,
  SupabaseProvider,
  useSupabase,
} from '/~/shared/providers/supabase/client.ts';
import { Database } from '/~/shared/api/supabase/types.generated.ts';
import { useMemo } from 'react';

export type SupabaseBrowserProviderConstructorArgs = WithChildren & {
  anonKey: string;
  supabaseUrl: string;
};

let singularSupabaseClient: SupabaseCreateClientResult | null = null;

export const SupabaseBrowserProviderConstructor = (
  { anonKey, children, supabaseUrl }: SupabaseBrowserProviderConstructorArgs,
) => {
  const exisitingSupabaseClient = useSupabase();

  if (!exisitingSupabaseClient && !singularSupabaseClient) {
    // TODO more elegant solution of `Multiple GoTrueClient instances detected in the same browser context. It is not an error, but this should be avoided as it may produce undefined behavior when used concurrently under the same storage key.` warning
    singularSupabaseClient = createClient<Database>(
      supabaseUrl,
      anonKey,
      // {
      // auth: {
      //   flowType: 'implicit',
      // },
      // },
    );
  }

  // const supabaseClient = useMemo(() =>
  //   exisitingSupabaseClient ||
  //   // createBrowserClient<Database>(
  //   createClient<Database>(
  //     supabaseUrl,
  //     anonKey,
  //     // {
  //     // auth: {
  //     //   flowType: 'implicit',
  //     // },
  //     // },
  //   ), [anonKey, children]);

  return (
    <SupabaseProvider value={exisitingSupabaseClient || singularSupabaseClient}>
      {children}
    </SupabaseProvider>
  );
};
