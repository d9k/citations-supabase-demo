import { useEffect } from 'react';
import { useTransition } from 'react';
import { useState } from 'react';

/**
 * skip SSR
 */
export const useRenderOnlyInBrowser = () => {
  const [isBrowser, setIsBrowser] = useState(false);
  // const [isPending, startTransition] = useTransition();

  /** useEffect runs only in browser */
  useEffect(() => {
    // startTransition(() => {
    setIsBrowser(true);
    // });
  }, []);

  return isBrowser;
};
