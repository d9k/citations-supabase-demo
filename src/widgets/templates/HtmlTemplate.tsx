import { ReactNode } from "react";
import { WithChildren } from "/~/shared/react/WithChildren.tsx";

export type HtmlTemplateProps = Partial<WithChildren> & {
    addHeaderChildren?: ReactNode,
    title?: string;
}

export const HtmlTemplate = ({
    children,
    addHeaderChildren,
    title = 'Ultra'
}: HtmlTemplateProps = {}) => {
    return (
        <html lang="en">
        <head>
            <meta charSet="utf-8" />
            <title>{title}</title>
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            { addHeaderChildren }
        </head>
        <body>
            {children}
        </body>
    </html>
);
}