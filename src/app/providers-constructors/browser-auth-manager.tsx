import { ReactNode } from 'react';

export type SupabaseBrowserAuthManagerProps = {
  children: ReactNode;
};

import {
  browserCookiesDeleteOnSupabaseSignOut,
  browserCookiesSetOnSupabaseAuth,
} from '/~/shared/api/supabase/browser-cookies.ts';
import {
  SupabaseUserProvider,
  useSupabaseUser,
} from '/~/shared/providers/supabase/user.ts';

import { useSupabase } from '/~/shared/providers/supabase/client.ts';
import { useEffect } from 'react';
import { useState } from 'react';

import { Session } from '@supabase/supabase-js';

export const SupabaseBrowserAuthManager = (
  { children }: SupabaseBrowserAuthManagerProps,
) => {
  const ssrSupabaseUser = useSupabaseUser();

  const supabase = useSupabase();

  // console.log('__TEST__: App: supabaseClient:', supabase);

  const [session, setSession] = useState<Session | null>(null);

  // useEffect runs on client only
  useEffect(() => {
    if (!supabase) {
      throw Error('Supabase not defined');
    }

    supabase.auth.getSession().then(({ data: { session } }) => {
      console.log('__TEST__: App: getSession: session:', session);

      setSession(session);
      if (session) {
        browserCookiesSetOnSupabaseAuth(session);
      }
    });

    supabase.auth.onAuthStateChange((event, session) => {
      console.log('__TEST__: App: onAuthStateChange: session:', session, event);

      setSession(session);

      /** @see https://supabase.com/docs/guides/auth/server-side-rendering#bringing-it-together */
      if (event === 'SIGNED_OUT' || (event as string) === 'USER_DELETED') {
        browserCookiesDeleteOnSupabaseSignOut();
      } else if (
        (event === 'SIGNED_IN' || event === 'TOKEN_REFRESHED') && session
      ) {
        browserCookiesSetOnSupabaseAuth(session);
      }
    });
  }, []);

  return (
    <SupabaseUserProvider value={ssrSupabaseUser || session?.user || null}>
      {children}
    </SupabaseUserProvider>
  );
};
