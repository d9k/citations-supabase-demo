import * as React from 'react';

import { RedirectWithRetPath } from '/~/shared/lib/react/routing/RedirectWithRetPath.tsx';
import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';
import { useSupabaseUser } from '/~/shared/providers/supabase/user.ts';

export const RedirectIfNoLogin = ({ children }: WithChildren) => {
  const user = useSupabaseUser();

  if (!user) {
    return <RedirectWithRetPath to='/login' />;
  }

  return <>{children}</>;
};
