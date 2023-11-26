import type { Meta, StoryObj } from '@storybook/react';
import meta, { Primary } from './LoginForm.stories.tsx';
import { userEvent, waitFor, within } from '@storybook/testing-library';
import { expect } from '@storybook/jest';
import { waitForMantineStylesLoaded } from '/~/shared/lib/storybook/waitForMantineStylesLoaded.ts';
import { LoginForm } from './index.tsx';

const tddMeta = {
  ...meta,
  title: 'Features/Auth/LoginForm',
  tags: [],
} satisfies Meta<typeof LoginForm>;

export default tddMeta;

type Story = StoryObj<typeof tddMeta>;

export const TestLoginRequired: Story = {
  args: {
    ...Primary.args,
  },
  async play(params: any) {
    const { canvasElement } = params;

    await waitForMantineStylesLoaded(canvasElement);

    const canvas = within(canvasElement);

    const inputEmailOrLogin = canvas.getByPlaceholderText('Email or login');
    const inputPassword = canvas.getByPlaceholderText('Your password');

    expect(inputEmailOrLogin).toHaveAttribute('required');
    expect(inputPassword).toHaveAttribute('required');
    await userEvent.type(inputEmailOrLogin, 'shrek@is.life');
    await userEvent.type(inputPassword, 'PrFiona');
  },
  // docs
};
