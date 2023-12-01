// deno-lint-ignore-file no-explicit-any

import { AppRoutes } from '/~/app/routes/index.tsx';
import { HtmlTemplate } from '/~/widgets/templates/HtmlTemplate.tsx';
import useAsset from 'ultra/hooks/use-asset.js';
// import useEnv from 'ultra/hooks/use-env.js';
import { BodyProvidersConstructor } from '/~/pages/providers-constructors/composite/body.tsx';
import { commonHeaderScriptsArray } from '/~/app/templates/headerScripts.tsx';
import { MantineColorSchemeScript } from '/~/pages/providers-constructors/helpers/colorSchemeScript.tsx';
import { useSupabase } from '/~/shared/providers/supabase/client.ts';
import { useEffect } from 'react';
import { useState } from 'react';

import { Session } from '@supabase/supabase-js';
import {
  browserCookiesDeleteOnSupabaseSignOut,
  browserCookiesSetOnSupabaseAuth,
} from '/~/shared/api/supabase/browser-cookies.ts';
import {
  SupabaseUserProvider,
  useSupabaseUser,
} from '/~/shared/providers/supabase/user.ts';

export type AppProps = {
  cache?: any;
};

export default function App({ cache }: AppProps) {
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

  // console.log('ULTRA_MODE:', useEnv("ULTRA_MODE"));
  // console.log('ULTRA_PUBLIC_SUPABASE_URL', useEnv('ULTRA_PUBLIC_SUPABASE_URL'));
  // console.log(
  //   'ULTRA_PUBLIC_SUPABASE_ANON_KEY',
  //   useEnv('ULTRA_PUBLIC_SUPABASE_ANON_KEY'),
  // );
  return (
    <SupabaseUserProvider value={ssrSupabaseUser || session?.user || null}>
      <HtmlTemplate
        title='Ultra'
        addHeaderChildren={
          <>
            <link rel='shortcut icon' href={useAsset('/favicon.ico')} />
            <MantineColorSchemeScript />
            {commonHeaderScriptsArray()}
          </>
        }
      >
        <BodyProvidersConstructor>
          <AppRoutes />
        </BodyProvidersConstructor>
      </HtmlTemplate>
    </SupabaseUserProvider>
  );
}
