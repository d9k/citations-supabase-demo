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

export type AppProps = {
  cache?: any;
};

export default function App({ cache }: AppProps) {
  const supabase = useSupabase();

  // console.log('__TEST__: App: supabaseClient:', supabase);

  const [session, setSession] = useState<Session | null>(null);

  useEffect(() => {
    if (!supabase) {
      throw Error('Supabase not defined');
    }

    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
    });

    supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session);
    });
  }, []);

  console.log('__TEST__: App: session:', session);

  // console.log('ULTRA_MODE:', useEnv("ULTRA_MODE"));
  // console.log('ULTRA_PUBLIC_SUPABASE_URL', useEnv('ULTRA_PUBLIC_SUPABASE_URL'));
  // console.log(
  //   'ULTRA_PUBLIC_SUPABASE_ANON_KEY',
  //   useEnv('ULTRA_PUBLIC_SUPABASE_ANON_KEY'),
  // );
  return (
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
  );
}
