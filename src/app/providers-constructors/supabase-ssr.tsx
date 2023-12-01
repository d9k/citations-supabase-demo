import { createServerClient } from '@supabase/ssr';
import { WithChildren } from '/~/shared/lib/react/WithChildren.tsx';
// import { SupabaseProvider } from '/~/shared/providers/supabase/client.ts';
import { Database } from '/~/shared/api/supabase/types.generated.ts';
// import { useMemo } from 'react';
import { createClient } from '@supabase/supabase-js';

// export type SupabaseServerProviderConstructorArgs = WithChildren & {
//   anonKey: string;
//   getCookie: (name: string) => string | undefined;
//   supabaseUrl: string;
// };

// export const SupabaseServerProviderConstructor = (
//   { anonKey, children, getCookie, supabaseUrl }:
//     SupabaseServerProviderConstructorArgs,
// ) => {
//   const supabaseClient = useMemo(() =>
//     createServerClient<Database>(
//       supabaseUrl,
//       anonKey,
//       {
//         auth: {
//           flowType: 'implicit',
//         },
//         cookies: {
//           get: getCookie,
//         },
//       },
//     ), [anonKey, getCookie, supabaseUrl]);

//   // const result = await supabaseClient.auth.getSession();

//   return <SupabaseProvider value={supabaseClient}>{children}</SupabaseProvider>;
// };

export type SsrSupabaseConstructorHelper = {
  anonKey: string;
  getCookie: (name: string) => string | undefined;
  supabaseAccessToken?: string;
  supabaseRefreshToken?: string;
  supabaseUrl: string;
};

export const ssrSupabaseConstructorHelper = async (
  {
    anonKey,
    getCookie,
    supabaseAccessToken,
    supabaseRefreshToken,
    supabaseUrl,
  }: SsrSupabaseConstructorHelper,
) => {
  // const supabaseClient = createServerClient<Database>(
  const supabaseClient = createClient<Database>(
    supabaseUrl,
    anonKey,
    // {
    //   auth: {
    //     flowType: 'implicit',
    //   },
    //   cookies: {
    //     get: getCookie,
    //   },
    // },
  );

  /** @see https://supabase.com/docs/guides/auth/server-side-rendering#bringing-it-together */
  // const supabaseSession = await supabaseClient.auth.getSession();

  let supabaseSession = null;

  if (supabaseAccessToken && supabaseRefreshToken) {
    supabaseSession = await supabaseClient.auth.setSession({
      refresh_token: supabaseRefreshToken,
      access_token: supabaseAccessToken,
      // {
      //   auth: { persistSession: false },
      // }
    });

    // console.log('__TEST__: server: supabaseSession:', supabaseSession);
    // console.log(
    //   '__TEST__: server: supabaseSession: user:',
    //   JSON.stringify(supabaseSession?.data?.user, null, '  '),
    // );

    // const supabaseUser = await supabaseClient.auth.getUser();
    // console.log(
    //   '__TEST__: server: supabaseUser:',
    //   JSON.stringify(supabaseUser, null, '  '),
    // );
  }

  return {
    supabaseClient,
    supabaseSession: supabaseSession || null,
    supabaseUser: supabaseSession?.data?.user || null,
  };
};
