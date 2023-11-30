import { createServerClient } from '@supabase/ssr';
import { WithChildren } from '/~/shared/lib/react/WithChildren.tsx';
import { SupabaseProvider } from '/~/shared/providers/supabase/client.ts';
import { Database } from '/~/shared/api/supabase/types.generated.ts';
import { useMemo } from 'react';

export type SupabaseServerProviderConstructorArgs = WithChildren & {
  anonKey: string;
  getCookie: (name: string) => string | undefined;
  supabaseUrl: string;
};

export const SupabaseServerProviderConstructor = (
  { anonKey, children, getCookie, supabaseUrl }:
    SupabaseServerProviderConstructorArgs,
) => {
  const supabaseClient = useMemo(() =>
    createServerClient<Database>(
      supabaseUrl,
      anonKey,
      {
        cookies: {
          get: getCookie,
        },
      },
    ), [anonKey, getCookie, supabaseUrl]);

  return <SupabaseProvider value={supabaseClient}>{children}</SupabaseProvider>;
};
