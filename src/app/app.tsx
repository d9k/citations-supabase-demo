// deno-lint-ignore-file no-explicit-any

import React, { lazy, Suspense } from 'react';
import { AppRoutes } from '/~/app/routes/index.tsx';
import { HtmlTemplate } from '/~/widgets/templates/HtmlTemplate.tsx';
import useAsset from 'ultra/hooks/use-asset.js';
// import useEnv from 'ultra/hooks/use-env.js';
import { BodyProvidersConstructor } from '/~/pages/providers-constructors/composite/body.tsx';
import { commonHeaderScriptsArray } from '/~/app/templates/headerScripts.tsx';
import { MantineColorSchemeScript } from '/~/pages/providers-constructors/helpers/colorSchemeScript.tsx';

const Comments = lazy(() => import('/~/entities/ui/comments.tsx'));

export type AppProps = {
  cache?: any;
};

export default function App({ cache }: AppProps) {
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
