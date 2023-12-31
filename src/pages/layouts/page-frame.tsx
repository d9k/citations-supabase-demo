import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';
import { LayoutHeader } from '/~/shared/ui/layout-header.tsx';
import { useSupabaseUser } from '/~/shared/providers/supabase/user.ts';
import { getMenuItems } from './menu-items.tsx';

import { AppShell, Burger } from '@mantine/core';

import { usePageFrameLayoutContext } from '/~/shared/providers/layout/page-frame/context.ts';

export const PageFrameLayout = (
  { children }: WithChildren,
) => {
  console.log('PageFrameLayout: redraw');

  const context = usePageFrameLayoutContext();

  const {
    navbarOpenedRef,
    navbarContentRef,
    rerendersCount,
    rerender,
  } = context;
  const supabaseUser = useSupabaseUser();
  const email = supabaseUser?.email;

  const navbarOpened = navbarOpenedRef.current;
  const navbarContent = navbarContentRef.current;

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
      data-rerenders-count={rerendersCount}
    >
      <AppShell.Header>
        <LayoutHeader
          menuItems={getMenuItems({ supabaseUser })}
        >
          {navbarContent &&
            (
              <Burger
                opened={navbarOpened}
                onClick={() => {
                  navbarOpenedRef.current = !navbarOpenedRef.current;
                  rerender();
                }}
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
