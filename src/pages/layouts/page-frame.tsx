import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';
import { LayoutHeader } from '/~/shared/ui/layout-header.tsx';
import { useSupabaseUser } from '/~/shared/providers/supabase/user.ts';

import { AppShell, Burger } from '@mantine/core';

import {
  PageFrameLayoutContextCreator,
  usePageFrameLayoutContext,
} from '/~/shared/providers/layout/page-frame.tsx';

export const PageFrameLayout = (
  { children }: WithChildren,
) => {
  const context = usePageFrameLayoutContext();

  const {
    navbarOpened,
    navbarOpenedSet,
    navbarContent,
  } = context;

  const supabaseUser = useSupabaseUser();
  const email = supabaseUser?.email;
  const userName = email?.split('@')[0];

  return (
    <AppShell
      header={{ height: 40 }}
      navbar={{
        width: 300,
        breakpoint: 'sm',
        collapsed: {
          desktop: !navbarOpened,
          mobile: !navbarOpened,
        },
      }}
      // padding={'md'}
      padding={20}
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
          ]}
        >
          {navbarContent &&
            (
              <Burger
                opened={navbarOpened}
                onClick={() => navbarOpenedSet((v) => !v)}
                size='md'
              />
            )}
          <div>Citations</div>
        </LayoutHeader>
      </AppShell.Header>

      {navbarContent &&
        <AppShell.Navbar p='md'>{navbarContent}</AppShell.Navbar>}

      <AppShell.Main>
        {children}
      </AppShell.Main>
    </AppShell>
  );
};
