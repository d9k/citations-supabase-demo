import { ReactNode } from 'react';

import {
  browserCookiesDeleteOnSupabaseSignOut,
  browserCookiesSetOnSupabaseAuth,
} from '/~/shared/api/supabase/browser-cookies.ts';
import {
  SupabaseUserProvider,
  useSupabaseUser,
} from '/~/shared/providers/supabase/user.ts';

import {
  SupabaseCreateClientResult,
  useSupabase,
} from '/~/shared/providers/supabase/client.ts';

import { Session } from '@supabase/supabase-js';
import { useQuery } from '@tanstack/react-query';
import { useState } from 'react';
import { useEffect } from 'react';

// let singularSupabaseSession: Session | null = null;

const createSupabaseSession = async (
  supabase: SupabaseCreateClientResult | null,
) => {
  if (!supabase) {
    throw Error('Supabase not defined');
  }

  const getSessionPromise = supabase.auth.getSession();

  // getSessionPromise.then(({ data: { session } }) => {
  //   console.log('__TEST__: App: getSession: session:', session);

  //   singularSupabaseSession = session;
  //   if (session) {
  //     browserCookiesSetOnSupabaseAuth(session);
  //   }
  // });

  return await getSessionPromise;
};

export type SupabaseBrowserAuthManagerProps = {
  children: ReactNode;
  queryKeyUniqueSuffix: string;
};

export const SupabaseBrowserAuthManager = (
  { children, queryKeyUniqueSuffix }: SupabaseBrowserAuthManagerProps,
) => {
  // const ssrSupabaseUser = useSupabaseUser();
  const supabase = useSupabase();

  const [session, setSession] = useState<Session | null | false>(false);

  const { data, error } = useQuery({
    queryKey: ['SsrSupabaseConstructor_' + queryKeyUniqueSuffix],
    queryFn: () => createSupabaseSession(supabase),
  });

  useEffect(() => {
    const newSession = data?.data?.session || null;
    if (newSession) {
      browserCookiesSetOnSupabaseAuth(newSession);
    }
    setSession(newSession);

    if (supabase) {
      supabase.auth.onAuthStateChange((event, newSession) => {
        console.log(
          '__TEST__: App: onAuthStateChange: session:',
          newSession,
          event,
        );

        // singularSupabaseSession = session;

        /** @see https://supabase.com/docs/guides/auth/server-side-rendering#bringing-it-together */
        if (event === 'SIGNED_OUT' || (event as string) === 'USER_DELETED') {
          browserCookiesDeleteOnSupabaseSignOut();
        } else if (
          (event === 'SIGNED_IN' || event === 'TOKEN_REFRESHED') && newSession
        ) {
          browserCookiesSetOnSupabaseAuth(newSession);
        }

        setSession(newSession);
      });
    }
  }, [data]);

  return (
    <SupabaseUserProvider
      value={(session === false ? data?.data?.session?.user : session?.user) ||
        null}
    >
      {children}
    </SupabaseUserProvider>
  );
};
