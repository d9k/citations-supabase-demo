import React, { ReactNode, useState } from 'react';
import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';
import { UseStateSetter } from '/~/shared/lib/react/hooks-types.ts';
import { useEffect } from 'react';

export type PageFrameLayoutProviderContextValueType = {
  navbarContent: ReactNode | null;
  navbarContentSet: UseStateSetter<ReactNode | null>;
  navbarOpened: boolean;
  navbarOpenedSet: UseStateSetter<boolean>;
};

export type PageFrameLayoutProviderContextUpdateProps = {
  navbarOpened?: boolean;
  navbarContent?: ReactNode | null;
} & Partial<WithChildren>;

export const PageFrameLayoutContext = React.createContext<
  PageFrameLayoutProviderContextValueType | null
>(null);

export const PageFrameLayoutContextProvider = PageFrameLayoutContext.Provider;

export const usePageFrameLayoutContext = ():
  | PageFrameLayoutProviderContextValueType
  | null => {
  return React.useContext(PageFrameLayoutContext);
};

export const PageFrameLayoutContextCreator = ({ children }: WithChildren) => {
  const [
    navbarOpened,
    navbarOpenedSet,
  ] = useState<boolean>(true);

  const [
    navbarContent,
    navbarContentSet,
  ] = useState<ReactNode | null>(false);

  const context: PageFrameLayoutProviderContextValueType = {
    navbarContent,
    navbarContentSet,
    navbarOpened,
    navbarOpenedSet,
  };

  return (
    <PageFrameLayoutContextProvider value={context}>
      {children}
    </PageFrameLayoutContextProvider>
  );
};

export const PageFrameLayoutProviderContextUpdate = ({
  children,
  navbarOpened,
  navbarContent,
}: PageFrameLayoutProviderContextUpdateProps) => {
  const context = usePageFrameLayoutContext();

  if (!context) {
    throw Error(
      'No <PageFrameLayoutContext> found. Try use <PageFrameLayoutProviderContextUpdate> inside <PageFrameLayout>',
    );
  }

  const {
    navbarOpenedSet,
    navbarContentSet,
  } = context;

  useEffect(() => {
    if (typeof navbarOpened !== 'undefined') {
      navbarOpenedSet(navbarOpened);
    }
  }, [navbarOpened]);

  useEffect(() => {
    if (typeof navbarContent !== 'undefined') {
      navbarContentSet(navbarContent);
    }
  }, [navbarContent]);

  return children;
};
