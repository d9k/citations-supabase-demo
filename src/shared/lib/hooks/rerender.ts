import { useCallback } from 'react';
import { useState } from 'react';

export type useRerenderResult = [number, () => void];

export const useRerender = (): useRerenderResult => {
  const [rerendersCount, setRerendersCount] = useState(0);

  const rerendersCountAdd = useCallback(() => {
    setRerendersCount((c) => c + 1);
  }, [setRerendersCount]);

  return [rerendersCount, rerendersCountAdd];
};
