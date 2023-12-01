import { NavLink } from 'react-router-dom';
import { WithChildren } from '/~/shared/lib/react/WithChildren.tsx';
import { LayoutHeader } from '/~/shared/ui/layout-header.tsx';
import { useSupabaseUser } from '/~/shared/providers/supabase/user.ts';

export const PageFrameLayout = ({ children }: WithChildren) => {
  const supabaseUser = useSupabaseUser();
  const email = supabaseUser?.email;

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
          {
            path: '/login',
            caption: 'Login',
          },
        ]}
        renderBelowHeader={() =>
          email
            ? (
              <div style={{ textAlign: 'right' }}>
                {email}
              </div>
            )
            : undefined}
      />

      <main>
        {children}
      </main>
    </>
  );
};
