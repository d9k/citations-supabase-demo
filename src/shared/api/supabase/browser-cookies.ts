import { Session } from '@supabase/supabase-js';
import {
  COOKIE_NAME_SUPABASE_ACCESS_TOKEN,
  COOKIE_NAME_SUPABASE_REFRESH_TOKEN,
} from './const.ts';

// export const COOKIE_OPTIONS = 'SameSite=Lax; secure';
export const COOKIE_OPTIONS = 'SameSite=Lax';

/**
 * @see https://supabase.com/docs/guides/auth/server-side-rendering#bringing-it-together
 */
export const browserCookiesSetOnSupabaseAuth = (session: Session) => {
  const age = 3 * 24 * 60 * 60; // 3 hours
  document.cookie =
    `${COOKIE_NAME_SUPABASE_ACCESS_TOKEN}=${session.access_token}; path=/; max-age=${age}; ${COOKIE_OPTIONS}`;
  document.cookie =
    `${COOKIE_NAME_SUPABASE_REFRESH_TOKEN}=${session.refresh_token}; path=/; max-age=${age}; ${COOKIE_OPTIONS}`;
};

export const browserCookiesDeleteOnSupabaseSignOut = () => {
  const expires = new Date(0).toUTCString();
  document.cookie =
    `${COOKIE_NAME_SUPABASE_ACCESS_TOKEN}=; path=/; expires=${expires}; ${COOKIE_OPTIONS}`;
  document.cookie =
    `${COOKIE_NAME_SUPABASE_REFRESH_TOKEN}=; path=/; expires=${expires}; ${COOKIE_OPTIONS}`;
};
