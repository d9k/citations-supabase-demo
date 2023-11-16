import { NavLink } from "react-router-dom";
import { WithChildren } from "/~/shared/react/WithChildren.tsx";
import { LayoutHeader } from "/~/shared/ui/layout-header.tsx";

export const PageFrameLayout = ({ children }: WithChildren) => (
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
        }
      ]}
    />
    <main>
      {children}
    </main>
  </>
);
