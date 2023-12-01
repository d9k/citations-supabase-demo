import { useLocation } from 'react-router-dom';

export default function useCurrentPath() {
  const { pathname, search, hash } = useLocation();
  return pathname + search + hash;
}
