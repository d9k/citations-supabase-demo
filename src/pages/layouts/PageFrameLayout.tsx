import { NavLink } from "react-router-dom";
import { WithChildren } from "/~/shared/react/WithChildren.tsx";

export const PageFrameLayout = ({ children }: WithChildren) => (
  <>
    <div>
      <NavLink to="/">Home</NavLink>
      <NavLink to="/demo">Demo</NavLink>
    </div>
    <main>
      {children}
    </main>
  </>
);
