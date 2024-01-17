import { User } from '@supabase/supabase-js';
import {
  profileCaptionFromUserName,
  userNameFromEmail,
} from '/~/shared/lib/user.ts';

export type GetMenuItemsProps = {
  supabaseUser: User | null;
};

export const getMenuItems = ({ supabaseUser }: GetMenuItemsProps) => {
  const email = supabaseUser?.email;
  const userName = userNameFromEmail(email);
  const profileCaption = profileCaptionFromUserName(userName);

  return [
    {
      path: '/',
      caption: 'Home',
    },
    {
      path: '/demo',
      caption: 'Demo',
    },
    {
      path: '/tables',
      pathMatchPattern: [
        { path: '/table', end: false },
        { path: '/tables', end: false },
      ],
      caption: 'Tables',
    },
    ...(supabaseUser
      ? [
        {
          path: '/profile',
          caption: profileCaption,
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
