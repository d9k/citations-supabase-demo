import type { Meta, StoryObj } from '@storybook/react';

import { waitFor, within, userEvent } from "@storybook/testing-library";
import { expect } from "@storybook/jest";

import { LoginForm } from './index.tsx';
import { waitForMantineStylesLoaded } from '/~/shared/lib/storybook/waitForMantineStylesLoaded.ts';

// More on how to set up stories at: https://storybook.js.org/docs/react/writing-stories/introduction#default-export
const meta = {
  title: 'shared/LoginForm',
  component: LoginForm,
  parameters: {
    // Optional parameter to center the component in the Canvas. More info: https://storybook.js.org/docs/react/configure/story-layout
    // layout: 'centered',
    layout: 'centered',
  },
  // This component will have an automatically generated Autodocs entry: https://storybook.js.org/docs/react/writing-docs/autodocs
  tags: ['autodocs'],
  // More on argTypes: https://storybook.js.org/docs/react/api/argtypes
  argTypes: {
    // backgroundColor: { control: 'color' },
  },
} satisfies Meta<typeof LoginForm>;

export default meta;
type Story = StoryObj<typeof meta>;

// More on writing stories with args: https://storybook.js.org/docs/react/writing-stories/args
export const Primary: Story = {
  args: {
    projectName: "Secret Project",
  },
};

export const TestLoginRequired: Story = {
  args: {
    ...Primary.args,
  },
  async play (params) {
    const {canvasElement} = params;

    await waitForMantineStylesLoaded(canvasElement);

    const canvas = within(canvasElement);

    const inputEmailOrLogin = canvas.getByPlaceholderText("Email or login");
    const inputPassword = canvas.getByPlaceholderText("Your password");

    expect(inputEmailOrLogin).toHaveAttribute('required');
    expect(inputPassword).toHaveAttribute('required');
    await userEvent.type(inputEmailOrLogin, "shrek@is.life");
    await userEvent.type(inputPassword, "PrFiona");
  }
}