import type { Meta, StoryObj } from '@storybook/react';

import { DemoMantineForm } from './DemoMantineForm.tsx';

const meta = {
  title: 'Example/DemoMantineForm',
  component: DemoMantineForm,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
} satisfies Meta<typeof DemoMantineForm>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {},
};
