import { ReactNode, useRef, useState } from 'react';
import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';
import { useCallback } from 'react';
import { PageFrameComponentType } from './types.ts';
import { PageFrameLayoutContextProvider } from './context.ts';
import { PageFrameLayoutProviderContextValueType } from './index.tsx';

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
