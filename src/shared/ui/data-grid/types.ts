import { ComboboxItem } from '@mantine/core';

export type SelectorItem = ComboboxItem;

export type ForeignIdToSelectorItem = {
  [id: string]: SelectorItem;
};
