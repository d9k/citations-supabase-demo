export const userNameFromEmail = (email?: string) => email?.split('@')[0];

export const profileCaptionFromUserName = (userName?: string) =>
  [userName, 'profile'].filter(Boolean).join(' ');
'profile';
