import { NavLink } from "react-router-dom";
import { WithChildren } from "/~/shared/react/WithChildren.tsx";
import { Header } from "/~/shared/ui/header.tsx";

export const PageFrameLayout = ({ children }: WithChildren) => (
  <>
    <Header
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
