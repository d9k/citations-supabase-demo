import { useParams } from 'react-router-dom';

export default function useUrlParamString(paramName: string): string | null {
  const value = useParams()[paramName];
  return value ? value : null;
}
