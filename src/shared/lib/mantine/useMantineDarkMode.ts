import { useMantineColorScheme } from '@mantine/core';

export const useMantineDarkMode = () => {
  const { colorScheme } = useMantineColorScheme();
  return colorScheme === 'dark';
};
