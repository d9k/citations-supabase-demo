import { ReactNode } from 'react';
import { WithChildren } from '/~/shared/lib/react/WithChildren.tsx';

export type HtmlTemplateProps = Partial<WithChildren> & {
  addHeaderChildren?: ReactNode;
  title?: string;
};

export const HtmlTemplate = ({
  children,
  addHeaderChildren,
  title = 'Ultra',
}: HtmlTemplateProps = {}) => {
  return (
    <html lang='en' data-mantine-color-scheme='dark'>
      <head>
        <meta charSet='utf-8' />
        <title>{title}</title>
        <meta name='viewport' content='width=device-width, initial-scale=1' />
        {addHeaderChildren}
      </head>
      <body>
        {children}
      </body>
    </html>
  );
};
