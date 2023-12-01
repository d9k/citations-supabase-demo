import { To } from 'react-router-dom';

export default function toUrlWithRetPath(
  toUrlPath: string,
  currentPath: string,
): To {
  const result: To = {
    pathname: toUrlPath,
  };

  if (currentPath !== '/') {
    result.search = `?retpath=${encodeURIComponent(currentPath)}`;
  }

  return result;
}
