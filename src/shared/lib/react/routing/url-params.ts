import { useParams } from 'react-router-dom';

export function useUrlParamString(paramName: string): string | null {
  const value = useParams()[paramName];
  return value ? value : null;
}

export function useUrlParamName(): string | null {
  return useUrlParamString('name') || null;
}
