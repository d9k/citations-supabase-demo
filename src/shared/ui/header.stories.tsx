import type { Meta, StoryObj } from '@storybook/react';

import { Header } from './header.tsx';
import { satisfies } from "../../../.ultra/vendor/server/deno.land/std@0.176.0/semver/mod.ts";

// More on how to set up stories at: https://storybook.js.org/docs/react/writing-stories/introduction#default-export
const meta = {
  title: 'shared/Header',
  component: Header,
  parameters: {
    // Optional parameter to center the component in the Canvas. More info: https://storybook.js.org/docs/react/configure/story-layout
    layout: 'centered',
  },
  // This component will have an automatically generated Autodocs entry: https://storybook.js.org/docs/react/writing-docs/autodocs
  tags: ['autodocs'],
  // More on argTypes: https://storybook.js.org/docs/react/api/argtypes
  // argTypes: {
  //   backgroundColor: { control: 'color' },
  // },
} satisfies Meta<typeof Header>

export default meta;

type Story = StoryObj<typeof Header>;


// More on writing stories with args: https://storybook.js.org/docs/react/writing-stories/args
export const Primary: Story = {
  args: {
    menuItems: [
      {
        path: '/books',
        caption: 'Books',
      },
      {
        path: '/authors',
        caption: 'Authors',
      },
      {
        path: '/publlishers',
        caption: 'Publishers',
      },
    ]
  },
};