import useUrlParamString from './useUrlParamString.ts';

export default function useUrlParamName(): string | null {
  return useUrlParamString('name') || null;
}
