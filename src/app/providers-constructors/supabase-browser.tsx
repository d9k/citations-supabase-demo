import { WithChildren } from '/~/shared/lib/react/WithChildren.tsx';
import { createBrowserClient } from '@supabase/ssr';
import { createClient } from '@supabase/supabase-js';
import { SupabaseProvider } from '/~/shared/providers/supabase/client.ts';
import { Database } from '/~/shared/api/supabase/types.generated.ts';
import { useMemo } from 'react';

export type SupabaseBrowserProviderConstructorArgs = WithChildren & {
  anonKey: string;
  supabaseUrl: string;
};

export const SupabaseBrowserProviderConstructor = (
  { anonKey, children, supabaseUrl }: SupabaseBrowserProviderConstructorArgs,
) => {
  const supabaseClient = useMemo(() =>
    // createBrowserClient<Database>(
    createClient<Database>(
      supabaseUrl,
      anonKey,
      // {
      // auth: {
      //   flowType: 'implicit',
      // },
      // },
    ), [anonKey, children]);

  return <SupabaseProvider value={supabaseClient}>{children}</SupabaseProvider>;
};
