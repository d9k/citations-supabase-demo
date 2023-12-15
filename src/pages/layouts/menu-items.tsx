import { useSupabaseUser } from '/~/shared/providers/supabase/user.ts';
import { MenuItem } from '/~/shared/ui/layout-header.tsx';
import { User } from '@supabase/supabase-js';

export type GetMenuItemsProps = {
  supabaseUser: User | null;
};

export const getMenuItems = ({ supabaseUser }: GetMenuItemsProps) => {
  const email = supabaseUser?.email;
  const userName = email?.split('@')[0];

  return [
    {
      path: '/',
      caption: 'Home',
    },
    {
      path: '/demo',
      caption: 'Demo',
    },
    ...(supabaseUser
      ? [
        {
          path: '/tables',
          pathMatchPattern: [
            { path: '/table', end: false },
            { path: '/tables', end: false },
          ],
          caption: 'Tables',
        },
        {
          path: '/profile',
          caption: `${userName} profile`,
        },
        {
          path: '/logout',
          caption: 'Log out',
        },
      ]
      : [
        {
          path: '/login',
          caption: 'Login',
        },
      ]),
  ];
};
