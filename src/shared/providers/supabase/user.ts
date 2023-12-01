import { createContext } from 'react';
import { User } from '@supabase/supabase-js';
import { useContext } from 'react';

export const SupabaseUserContext = createContext<
  User | null
>(null);

export const SupabaseUserProvider = SupabaseUserContext.Provider;

export const useSupabaseUser = () => {
  return useContext(SupabaseUserContext);
};
