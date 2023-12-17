import { ReactNode, useState } from 'react';
import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';
import { UseRefResult } from '/~/shared/lib/react/hooks-types.ts';
import { useEffect } from 'react';
import { PageFrameComponentType } from './types.ts';
import { usePageFrameLayoutContext } from './context.ts';

export type PageFrameLayoutProviderContextUpdateProps = {
  navbarOpened?: boolean;
  navbarContent?: ReactNode | null;
  pageFrameComponent?: PageFrameComponentType;
  forceRerender?: boolean;
} & Partial<WithChildren>;

export const PageFrameLayoutProviderContextUpdate = (
  props: PageFrameLayoutProviderContextUpdateProps,
) => {
  const {
    children,
    forceRerender,
    navbarOpened,
    navbarContent,
    pageFrameComponent,
  } = props;

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
    debugLabel = '',
  ) => {
    if (
      typeof newValue !== 'undefined' &&
      !rerenderingRef.current
    ) {
      if (ref.current !== newValue) {
        console.debug(
          `PageFrameLayoutProviderContextUpdate: changing "${debugLabel}" ref value: from`,
          ref.current,
          'to',
          newValue,
          'Props were:',
          props,
        );
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

  updateRef(navbarOpenedRef, navbarOpened, 'navbarOpened');
  updateRef(navbarContentRef, navbarContent, 'navbarContent');
  updateRef(pageFrameComponentRef, pageFrameComponent, 'pageFrameComponent');

  if (forceRerender && anyRefUpdated && !firstTime) {
    setTimeout(() => {
      console.log(
        `PageFrameLayoutProviderContextUpdate: causing rerender. Props were`,
        props,
      );
      rerender();
    }, 0);
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
