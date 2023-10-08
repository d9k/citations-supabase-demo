import { ReactNode } from "react";
import { Button, MantineProvider } from '@mantine/core';
import { WithChildren } from "/~/shared/react/WithChildren.tsx";

export type MantineProviderModProps = Partial<WithChildren>;

export function MantineProviderMod({ children }: MantineProviderModProps) {
  return (
    <MantineProvider>
      {children}
    </MantineProvider>
  );
}