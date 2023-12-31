// deno-lint-ignore-file no-explicit-any

import { Helmet } from 'react-helmet-async';
import { AppRoutes } from '/~/app/routes/index.tsx';
import { Notifications } from '@mantine/notifications';

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
    <>
      {
        /* <Helmet prioritizeSeoTags>
        <title>__TEST__</title>
      </Helmet> */
      }
      <Notifications />
      <AppRoutes />
    </>
  );
}
