// import { useEffect } from 'react';
import React, { ReactNode, useState } from 'react';
import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';
import { UseStateSetter } from '/~/shared/lib/react/hooks-types.ts';
import { useCallback } from 'react';

export type PageFrameComponentType = React.ElementType;
/** We can't store function in useState */
export type PageFrameComponentWrappedType = () => React.ElementType;

export type PageFrameLayoutProviderContextValueType = {
  navbarContent: ReactNode | null;
  navbarContentSet: UseStateSetter<ReactNode | null>;
  navbarOpened: boolean;
  navbarOpenedSet: UseStateSetter<boolean>;
  PageFrameComponent: PageFrameComponentType;
  pageFrameComponentSet: (p: PageFrameComponentType) => void;
};

export type PageFrameLayoutProviderContextUpdateProps = {
  navbarOpened?: boolean;
  navbarContent?: ReactNode | null;
  pageFrameComponent?: PageFrameComponentType;
} & Partial<WithChildren>;

export const PageFrameLayoutContext = React.createContext<
  PageFrameLayoutProviderContextValueType | null
>(null);

export const PageFrameLayoutContextProvider = PageFrameLayoutContext.Provider;

export const usePageFrameLayoutContext =
  (): PageFrameLayoutProviderContextValueType => {
    const context = React.useContext(PageFrameLayoutContext);

    if (!context) {
      throw Error(
        'No <PageFrameLayoutContextCreator> found. <PageFrameLayout> must be used inside this component',
      );
    }

    return context;
  };

export type PageFrameLayoutContextCreatorProps = WithChildren & {
  pageFrameComponent: PageFrameComponentType;
};

export const PageFrameLayoutContextCreator = (
  { children, pageFrameComponent }: PageFrameLayoutContextCreatorProps,
) => {
  const [
    navbarOpened,
    navbarOpenedSet,
  ] = useState<boolean>(false);

  const [
    PageFrameComponent,
    pageFrameComponentSetFromWrapped,
  ] = useState<PageFrameComponentType>(() => pageFrameComponent);

  const pageFrameComponentSet = useCallback(
    (p: PageFrameComponentType) => {
      return pageFrameComponentSetFromWrapped(() => p);
    },
    [pageFrameComponentSetFromWrapped],
  );

  const [
    navbarContent,
    navbarContentSet,
  ] = useState<ReactNode | null>(false);

  const context: PageFrameLayoutProviderContextValueType = {
    navbarContent,
    navbarContentSet,
    navbarOpened,
    navbarOpenedSet,
    PageFrameComponent: PageFrameComponent,
    pageFrameComponentSet,
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
  pageFrameComponent,
}: PageFrameLayoutProviderContextUpdateProps) => {
  const context = usePageFrameLayoutContext();
  // const [isPending, startTransition] = useTransition();

  if (!context) {
    throw Error(
      'No <PageFrameLayoutContextCreator> found. <PageFrameLayoutProviderContextUpdate> must be used inside this component',
    );
  }

  const {
    navbarOpenedSet,
    navbarContentSet,
    pageFrameComponentSet,
  } = context;

  // useEffect(() => {
  if (typeof navbarOpened !== 'undefined') {
    // startTransition(() => {
    navbarOpenedSet(navbarOpened);
    // });
  }
  // }, [navbarOpened]);

  // useEffect(() => {
  if (typeof navbarContent !== 'undefined') {
    // startTransition(() => {
    navbarContentSet(navbarContent);
    // });
  }
  // }, [navbarContent]);

  if (typeof pageFrameComponent !== 'undefined') {
    // startTransition(() => {
    navbarContentSet(navbarContent);
    // });
  }

  if (typeof pageFrameComponent !== 'undefined') {
    pageFrameComponentSet(pageFrameComponent);
  }

  // if (typeof navbarOpened !== 'undefined') {
  //   navbarOpenedSet(navbarOpened);
  // }
  // if (typeof navbarContent !== 'undefined') {
  //   navbarContentSet(navbarContent);
  // }

  return children;
};
