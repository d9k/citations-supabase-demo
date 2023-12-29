import { StringParam, useQueryParam } from 'use-query-params';

export function useQueryParamString(name: string): string | undefined {
  const [result] = useQueryParam(name, StringParam);

  return result || undefined;
}
export const useQueryParamName = () => useQueryParamString('name');
export const useQueryParamRetPath = () => useQueryParamString('retpath');
