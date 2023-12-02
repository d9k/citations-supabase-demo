import { Navigate } from 'react-router-dom';
import useCurrentUrlPath from './useCurrentPath.ts';
import toUrlWithRetPath from './toUrlWithRetpath.ts';

export type RedirectWithRetPathProps = {
  to: string;
};

export const RedirectWithRetPath = ({ to }: RedirectWithRetPathProps) => {
  const currentPath = useCurrentUrlPath();

  return <Navigate to={toUrlWithRetPath(to, currentPath)} />;
};
