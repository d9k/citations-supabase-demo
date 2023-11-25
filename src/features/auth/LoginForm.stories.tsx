import type { Meta, StoryObj } from '@storybook/react';
import { LoginForm } from './index.tsx';

const meta = {
  title: 'features/Auth/LoginForm',
  component: LoginForm,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
} satisfies Meta<typeof LoginForm>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {},
};

export const Secondary: Story = {
  args: {},
  tags: [],
};
