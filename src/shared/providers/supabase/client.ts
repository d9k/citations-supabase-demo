import { createContext } from 'react';
import { createBrowserClient, createServerClient } from '@supabase/ssr';
import { useContext } from 'react';
import { Database } from '/~/shared/api/supabase/types.generated.ts';

export type SupabaseCreateClientResult =
  | ReturnType<typeof createBrowserClient<Database>>
  | ReturnType<typeof createServerClient<Database>>;

export const SupabaseContext = createContext<
  SupabaseCreateClientResult | null
>(null);

export const SupabaseProvider = SupabaseContext.Provider;

export const useSupabase = () => {
  return useContext(SupabaseContext);
};
