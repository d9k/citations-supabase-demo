// deno-lint-ignore-file no-explicit-any

import { AppRoutes } from '/~/app/routes/index.tsx';

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
  return <AppRoutes />;
}
