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
import { useEffect, useState } from 'react';
import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';
import { useRef } from 'react';
import { useCallback } from 'react';

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

export type SupabaseBrowserAuthManagerProps = WithChildren & {
  queryKeyUniqueSuffix: string;
};

export const ELEMENT_NAME = 'SupabaseBrowserAuthManager';

export const SupabaseBrowserAuthManager = (
  { children, queryKeyUniqueSuffix }: SupabaseBrowserAuthManagerProps,
) => {
  console.debug(`${ELEMENT_NAME} rerender`);

  // const ssrSupabaseUser = useSupabaseUser();
  const supabase = useSupabase();

  const [session, setSessionRaw] = useState<Session | null | false>(false);

  const sessionRef = useRef(session);

  const setSession = useCallback((newSession: Session | null) => {
    /**
     * Prevent forced redraw on tab focus:
     * [onAuthStateChange (SIGNED\_IN event) Fired everytime I change Chrome Tab or refocus on tab . · Issue #7250 · supabase/supabase](https://github.com/supabase/supabase/issues/7250)
     */
    if (JSON.stringify(sessionRef.current) === JSON.stringify(newSession)) {
      console.debug(`${ELEMENT_NAME} : no update, the same`);
      return;
    }

    console.debug(`${ELEMENT_NAME} : update, new session`);

    sessionRef.current = newSession;
    setSession(newSession);
  }, [setSessionRaw]);

  const { data, error } = useQuery({
    queryKey: [ELEMENT_NAME, queryKeyUniqueSuffix],
    queryFn: () => createSupabaseSession(supabase),
  });

  useEffect(() => {
    console.log(`${ELEMENT_NAME}: useEffect on data changed`);

    const newSession = data?.data?.session || null;
    if (newSession) {
      browserCookiesSetOnSupabaseAuth(newSession);
    }
    setSession(newSession);

    if (supabase) {
      supabase.auth.onAuthStateChange((event, newSession) => {
        console.log(
          `{ELEMENT_NAME}: App: onAuthStateChange: session:`,
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
