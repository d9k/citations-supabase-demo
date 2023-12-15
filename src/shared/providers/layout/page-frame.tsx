// import { useEffect } from 'react';
import React, { ReactNode, useRef, useState } from 'react';
import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';
import { UseRefResult } from '/~/shared/lib/react/hooks-types.ts';
import { useCallback } from 'react';
import { useToggle } from '@mantine/hooks';
import { useEffect } from 'react';

export type PageFrameComponentType = React.ElementType;
/** We can't store function in useState */
export type PageFrameComponentWrappedType = () => React.ElementType;

export type PageFrameLayoutProviderContextValueType = {
  navbarContentRef: UseRefResult<ReactNode | null>;
  navbarOpenedRef: UseRefResult<boolean>;
  pageFrameComponentRef: UseRefResult<PageFrameComponentType>;
  rerender: () => void;
  rerendersCount: number;
  rerenderingRef: UseRefResult<boolean>;
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

export const usePageFrameLayoutComponent = (): PageFrameComponentType => {
  const { pageFrameComponentRef } = usePageFrameLayoutContext();
  return pageFrameComponentRef.current;
};

export type PageFrameLayoutContextCreatorProps = WithChildren & {
  pageFrameComponent: PageFrameComponentType;
};

export const PageFrameLayoutContextCreator = (
  { children, pageFrameComponent }: PageFrameLayoutContextCreatorProps,
) => {
  const navbarContentRef = useRef<ReactNode | null>(null);
  const navbarOpenedRef = useRef<boolean>(false);
  const pageFrameComponentRef = useRef<PageFrameComponentType>(
    pageFrameComponent,
  );
  const rerenderingRef = useRef<boolean>(false);

  const [rerendersCount, rerendersCountSet] = useState(0);

  const rerender = useCallback(() => {
    if (rerenderingRef.current) {
      return;
    }
    rerenderingRef.current = true;
    rerendersCountSet((c) => c + 1);
    setTimeout(() => {
      rerenderingRef.current = false;
    }, 0);
  }, [rerendersCountSet]);

  const context: PageFrameLayoutProviderContextValueType = {
    navbarContentRef,
    navbarOpenedRef,
    pageFrameComponentRef,
    rerender,
    rerenderingRef,
    rerendersCount,
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

  const [firstTime, setFirstTime] = useState(true);

  useEffect(() => {
    setFirstTime(false);
  }, [firstTime]);

  let anyRefUpdated = false;

  const {
    navbarOpenedRef,
    navbarContentRef,
    pageFrameComponentRef,
    rerender,
    rerenderingRef,
  } = context;

  const updateRef = <T,>(
    ref: UseRefResult<T>,
    newValue: T | undefined,
  ) => {
    if (
      typeof newValue !== 'undefined' &&
      !rerenderingRef.current
    ) {
      if (ref.current !== newValue) {
        ref.current = newValue;
        anyRefUpdated = true;
      }
    }
  };

  if (!context) {
    throw Error(
      'No <PageFrameLayoutContextCreator> found. <PageFrameLayoutProviderContextUpdate> must be used inside this component',
    );
  }

  updateRef(navbarOpenedRef, navbarOpened);
  updateRef(navbarContentRef, navbarContent);
  updateRef(pageFrameComponentRef, pageFrameComponent);

  if (anyRefUpdated && !firstTime) {
    rerender();
  }

  // useEffect(() => {
  // if (typeof navbarOpened !== 'undefined') {
  //   // startTransition(() => {
  //   navbarOpenedSet(navbarOpened);
  //   // });
  // }
  // }, [navbarOpened]);

  // // useEffect(() => {
  // if (typeof navbarContent !== 'undefined') {
  //   // startTransition(() => {
  //   navbarContentSet(navbarContent);
  //   // });
  // }
  // // }, [navbarContent]);

  // if (typeof pageFrameComponent !== 'undefined') {
  //   // startTransition(() => {
  //   navbarContentSet(navbarContent);
  //   // });
  // }

  // if (typeof pageFrameComponent !== 'undefined') {
  //   pageFrameComponentSet(pageFrameComponent);
  // }

  // if (typeof navbarOpened !== 'undefined') {
  //   navbarOpenedSet(navbarOpened);
  // }
  // if (typeof navbarContent !== 'undefined') {
  //   navbarContentSet(navbarContent);
  // }

  return children;
};
