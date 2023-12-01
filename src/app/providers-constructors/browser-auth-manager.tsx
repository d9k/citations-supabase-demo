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
import { useEffect } from 'react';
import { useState } from 'react';

import { Session } from '@supabase/supabase-js';
import { useQuery } from '@tanstack/react-query';

let singularSupabaseSession: Session | null = null;

const createSupabaseSession = async (
  supabase: SupabaseCreateClientResult | null,
  // setSession: (s: Session | null) => void,
) => {
  if (!supabase) {
    throw Error('Supabase not defined');
  }

  const getSessionPromise = supabase.auth.getSession();

  getSessionPromise.then(({ data: { session } }) => {
    console.log('__TEST__: App: getSession: session:', session);

    // setSession(session);
    singularSupabaseSession = session;
    if (session) {
      browserCookiesSetOnSupabaseAuth(session);
    }
  });

  supabase.auth.onAuthStateChange((event, session) => {
    console.log('__TEST__: App: onAuthStateChange: session:', session, event);

    // setSession(session);
    singularSupabaseSession = session;

    /** @see https://supabase.com/docs/guides/auth/server-side-rendering#bringing-it-together */
    if (event === 'SIGNED_OUT' || (event as string) === 'USER_DELETED') {
      browserCookiesDeleteOnSupabaseSignOut();
    } else if (
      (event === 'SIGNED_IN' || event === 'TOKEN_REFRESHED') && session
    ) {
      browserCookiesSetOnSupabaseAuth(session);
    }
  });

  return await getSessionPromise;
};

export type SupabaseBrowserAuthManagerProps = {
  children: ReactNode;
  queryKeyUniqueSuffix: string;
};

export const SupabaseBrowserAuthManager = (
  { children, queryKeyUniqueSuffix }: SupabaseBrowserAuthManagerProps,
) => {
  const ssrSupabaseUser = useSupabaseUser();

  const supabase = useSupabase();

  // console.log('__TEST__: App: supabaseClient:', supabase);

  // const [session, setSession] = useState<Session | null>(null);

  // useEffect runs on client only
  // useEffect(() => {
  // }, []);

  const { data, error } = useQuery({
    // const { data, error } = useSuspenseQuery({
    queryKey: ['SsrSupabaseConstructor_' + queryKeyUniqueSuffix],
    // queryFn: () => createSupabaseSession(supabase, setSession),
    queryFn: () => createSupabaseSession(supabase),
    // queryFn: async () => {
    //   await sleepMs(300);
    //   return { supabaseClient: null, supabaseUser: null };
    // },
  });

  return (
    <SupabaseUserProvider
      value={ssrSupabaseUser || singularSupabaseSession?.user || null}
    >
      {children}
    </SupabaseUserProvider>
  );
};
