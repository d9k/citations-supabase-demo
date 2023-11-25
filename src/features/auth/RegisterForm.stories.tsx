import type { Meta, StoryObj } from '@storybook/react';

import { RegisterForm } from './RegisterForm.tsx';

const meta = {
  title: 'features/Auth/RegisterForm',
  component: RegisterForm,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
} satisfies Meta<typeof RegisterForm>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {
    projectName: 'Secret Project',
  },
};

export const Secondary: Story = {
  args: {
    projectName: 'Another Secret Project',
  },
  tags: [],
};
