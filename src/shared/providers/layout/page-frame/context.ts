import React from 'react';
import { PageFrameLayoutProviderContextValueType } from './index.tsx';

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
