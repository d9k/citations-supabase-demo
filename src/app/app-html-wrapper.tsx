import { AppRoutes } from '/~/app/routes/index.tsx';
import { HtmlTemplate } from '/~/widgets/templates/HtmlTemplate.tsx';
import useAsset from 'ultra/hooks/use-asset.js';
// import useEnv from 'ultra/hooks/use-env.js';
import { AppProvidersConstructor } from '../pages/providers-constructors/composite/app.tsx';
import { useCommonHeaderScriptsArray } from '/~/app/templates/headerScripts.tsx';
import { MantineColorSchemeScript } from '/~/pages/providers-constructors/helpers/colorSchemeScript.tsx';
import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';

export default function AppHtmlWrapper({ children }: WithChildren) {
  // console.log('ULTRA_MODE:', useEnv("ULTRA_MODE"));
  // console.log('ULTRA_PUBLIC_SUPABASE_URL', useEnv('ULTRA_PUBLIC_SUPABASE_URL'));
  // console.log(
  //   'ULTRA_PUBLIC_SUPABASE_ANON_KEY',
  //   useEnv('ULTRA_PUBLIC_SUPABASE_ANON_KEY'),
  // );
  return (
    <HtmlTemplate
      addHeaderChildren={
        <>
          <link rel='shortcut icon' href={useAsset('/favicon.ico')} />
          <MantineColorSchemeScript />
          {useCommonHeaderScriptsArray()}
        </>
      }
    >
      {children}
    </HtmlTemplate>
  );
}
