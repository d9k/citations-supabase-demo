import { StringParam, useQueryParam } from 'use-query-params';

export function useUrlParamRetPath(): string | undefined {
  const [retPath] = useQueryParam('retpath', StringParam);

  return retPath || undefined;
}
