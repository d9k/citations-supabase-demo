import { NavLink } from 'react-router-dom';
import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';
import { LayoutHeader } from '/~/shared/ui/layout-header.tsx';
import { useSupabaseUser } from '/~/shared/providers/supabase/user.ts';

import { AppShell, Burger } from '@mantine/core';
import { useDisclosure } from '@mantine/hooks';

export const PageFrameLayout = ({ children }: WithChildren) => {
  const supabaseUser = useSupabaseUser();
  const email = supabaseUser?.email;
  const userName = email?.split('@')[0];
  const [
    navbarOpened,
    { toggle: navbarToggle },
  ] = useDisclosure();

  return (
    <AppShell
      header={{ height: 30 }}
      navbar={{
        width: 300,
        breakpoint: 'sm',
        collapsed: {
          desktop: !navbarOpened,
          mobile: !navbarOpened,
        },
      }}
      padding='md'
    >
      <AppShell.Header>
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
        >
          <Burger
            opened={navbarOpened}
            onClick={navbarToggle}
            size='md'
          />
          <div>Citations</div>
        </LayoutHeader>
      </AppShell.Header>

      <AppShell.Navbar p='md'>Navbar</AppShell.Navbar>

      <AppShell.Main>
        {children}
      </AppShell.Main>
    </AppShell>
  );
};
