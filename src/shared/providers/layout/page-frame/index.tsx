// import { useEffect } from 'react';
import { ReactNode } from 'react';
import { UseRefResult } from '/~/shared/lib/react/hooks-types.ts';
import { PageFrameComponentType } from './types.ts';
import { usePageFrameLayoutContext } from './context.ts';

export type PageFrameLayoutProviderContextValueType = {
  navbarContentRef: UseRefResult<ReactNode | null>;
  navbarOpenedRef: UseRefResult<boolean>;
  pageFrameComponentRef: UseRefResult<PageFrameComponentType>;
  rerender: () => void;
  rerendersCount: number;
  rerenderingRef: UseRefResult<boolean>;
};

export const usePageFrameLayoutComponent = (): PageFrameComponentType => {
  const { pageFrameComponentRef } = usePageFrameLayoutContext();
  return pageFrameComponentRef.current;
};

export * from './context-updater.tsx';
export * from './context-creator.tsx';
export * from './types.ts';
export * from './context.ts';
