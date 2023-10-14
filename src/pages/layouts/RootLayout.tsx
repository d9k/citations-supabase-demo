import { HtmlTemplate } from '/~/widgets/templates/HtmlTemplate.tsx';
import { WithChildren } from '/~/shared/react/WithChildren.tsx';
import useAsset from 'ultra/hooks/use-asset.js';
import { BodyProviders } from '/~/pages/providers/body.tsx';
import { ColorSchemeScript } from '@mantine/core';

export const RootLayout = ({children}: WithChildren) => (
  <HtmlTemplate
    title="Ultra"
    addHeaderChildren={(
      <>
        <link rel="shortcut icon" href={useAsset("/favicon.ico")} />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@mantine/core@7.1.2/esm/index.css" />
        <link rel="stylesheet" href={useAsset("/style.css")} />
        <ColorSchemeScript />
      </>
    )}
  >
    <BodyProviders>
        {children}
    </BodyProviders>
  </HtmlTemplate>
)