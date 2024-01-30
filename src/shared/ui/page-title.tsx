import useEnv from 'ultra/hooks/use-env.js';
import { Helmet } from 'react-helmet-async';

export type PageTitleProps = {
  tabTitle?: string;
  children: string;
};

export const PageTitle = ({ children, tabTitle }: PageTitleProps) => {
  const ULTRA_PUBLIC_APP_NAME = useEnv('ULTRA_PUBLIC_APP_NAME');

  const tabTitleParts = [ULTRA_PUBLIC_APP_NAME];

  if (tabTitle !== '') {
    tabTitleParts.unshift(tabTitle || children);
  }

  return (
    <>
      <Helmet>
        <title>{tabTitleParts.join(' | ')}</title>
      </Helmet>
      <h1>
        {children}
      </h1>
    </>
  );
};
