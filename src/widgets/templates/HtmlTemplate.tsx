import { ReactNode } from 'react';
import { WithChildren } from '/~/shared/lib/react/WithChildren.ts';
import useEnv from 'ultra/hooks/use-env.js';

export type HtmlTemplateProps = Partial<WithChildren> & {
  addHeaderChildren?: ReactNode;
  title?: string;
};

export const HtmlTemplate = ({
  children,
  addHeaderChildren,
  title,
}: HtmlTemplateProps = {}) => {
  const currentTitle = title || useEnv('ULTRA_PUBLIC_APP_NAME');

  return (
    <html lang='en' data-mantine-color-scheme='dark'>
      <head>
        <meta charSet='utf-8' />
        <title>{currentTitle}</title>
        <meta name='viewport' content='width=device-width, initial-scale=1' />
        {addHeaderChildren}
      </head>
      <body>
        {children}
      </body>
    </html>
  );
};
