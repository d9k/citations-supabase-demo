import { createServerClient } from '@supabase/ssr';
import { WithChildren } from '/~/shared/lib/react/WithChildren.tsx';
// import { SupabaseProvider } from '/~/shared/providers/supabase/client.ts';
import { Database } from '/~/shared/api/supabase/types.generated.ts';
// import { useMemo } from 'react';
import { createClient } from '@supabase/supabase-js';
import { useQuery, useSuspenseQuery } from '@tanstack/react-query';

import {
  SupabaseCreateClientResult,
  SupabaseProvider,
  SupabaseUserProvider,
} from '/~/shared/providers/supabase/index.ts';
import { sleepMs } from '/~/shared/lib/sys/sleep.ts';
import { wrapPromiseForSuspend } from '/~/shared/lib/react/wrapPromiseForSuspend.js';

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

export type SsrSupabaseConstructorHelperArgs = {
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
  }: SsrSupabaseConstructorHelperArgs,
) => {
  console.log('__TEST__ ssrSupabaseConstructorHelper begin');

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

export type SsrSupabaseConstructorProps =
  & WithChildren
  & SsrSupabaseConstructorHelperArgs
  & { queryKeyUniqueSuffix: string };

const testAsyncFn = async (i: number) => {
  await sleepMs(3000);
  return i ^ 2;
};

const promise = testAsyncFn(2);
const wrappedPromise = wrapPromiseForSuspend(promise);

export const SsrSupabaseConstructor = (
  { children, queryKeyUniqueSuffix, ...restProps }: SsrSupabaseConstructorProps,
) => {
  const { data, error } = useQuery({
    // const { data, error } = useSuspenseQuery({
    queryKey: ['SsrSupabaseConstructor_' + queryKeyUniqueSuffix],
    // queryFn: () => ssrSupabaseConstructorHelper({ ...restProps }),
    queryFn: async () => {
      await sleepMs(300);
      return { supabaseClient: null, supabaseUser: null };
    },
  });

  // const result = wrappedPromise.read();

  // console.log(result);

  // const { supabaseClient, supabaseUser } = data as unknown as ReturnType<typeof ssrSupabaseConstructorHelper>;
  const { supabaseClient = null, supabaseUser = null } = data || {};
  // const { supabaseClient = null, supabaseUser = null } = {};

  return (
    <SupabaseProvider value={supabaseClient}>
      <SupabaseUserProvider value={supabaseUser}>
        {children}
      </SupabaseUserProvider>
    </SupabaseProvider>
  );
  // return (
  //   <>
  //     {
  //       /* <script
  //       dangerouslySetInnerHTML={{
  //         __html: 'window._WRAPPED_PROMISE_TEST = ' +
  //           JSON.stringify(result),
  //       }}
  //     /> */
  //     }
  //     {children}
  //   </>
  // );
};
