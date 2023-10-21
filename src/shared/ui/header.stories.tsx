import type { Meta, StoryObj } from '@storybook/react';

import { Header } from './header.tsx';

// More on how to set up stories at: https://storybook.js.org/docs/react/writing-stories/introduction#default-export
const meta: Meta<typeof Header> = {
  title: 'shared/Header',
  component: Header,
  parameters: {
    layout: 'fullscreen',
  },
  tags: ['autodocs'],
  // argTypes: {
  //   backgroundColor: { control: 'color' },
  // },
} //satisfies Meta<typeof Header>

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
        active: true,
      },
      {
        path: '/publlishers',
        caption: 'Publishers',
      },
    ]
  },
};

export const WithChildren = {
  args: {
    ...Primary.args,
    children: <h1>Logo</h1>
  }
};