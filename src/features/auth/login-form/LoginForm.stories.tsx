import type { Meta, StoryObj } from '@storybook/react';

import { userEvent, waitFor, within } from '@storybook/testing-library';
import { expect } from '@storybook/jest';

import { LoginForm } from './index.tsx';
import { waitForMantineStylesLoaded } from '/~/shared/lib/storybook/waitForMantineStylesLoaded.ts';

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
