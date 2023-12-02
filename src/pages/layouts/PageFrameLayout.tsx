import { NavLink } from 'react-router-dom';
import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';
import { LayoutHeader } from '/~/shared/ui/layout-header.tsx';
import { useSupabaseUser } from '/~/shared/providers/supabase/user.ts';

export const PageFrameLayout = ({ children }: WithChildren) => {
  const supabaseUser = useSupabaseUser();
  const email = supabaseUser?.email;
  const userName = email?.split('@')[0];

  return (
    <>
      <LayoutHeader
        menuItems={[
          {
            path: '/',
            caption: 'Home',
          },
          {
            path: '/demo',
            caption: 'Demo',
          },
          ...(supabaseUser
            ? [{
              path: '/profile',
              caption: `${userName} profile`,
            }, {
              path: '/logout',
              caption: 'Log out',
            }]
            : [
              {
                path: '/login',
                caption: 'Login',
              },
            ]),
        ]}
      />

      <main>
        {children}
      </main>
    </>
  );
};
