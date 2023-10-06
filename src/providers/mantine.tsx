import { ReactNode } from "react";
import { Button, MantineProvider } from '@mantine/core';

export type MantineProviderModProps = {
  children?: ReactNode;
}

export function MantineProviderMod({ children }: MantineProviderModProps) {
  return (
    <MantineProvider>
      {children}
    </MantineProvider>
  );
}