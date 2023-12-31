import type { Meta, StoryObj } from '@storybook/react';

import {
  DemoFelaColorBlock,
  DemoFelaColorBlockProps,
} from './demoFelaColorBlock';
import { Button } from '@mantine/core';

// More on how to set up stories at: https://storybook.js.org/docs/react/writing-stories/introduction#default-export
const meta = {
  title: 'Demo/DemoFelaColorBlock',
  component: DemoFelaColorBlock,
  parameters: {
    // Optional parameter to center the component in the Canvas. More info: https://storybook.js.org/docs/react/configure/story-layout
    layout: 'centered',
  },
  // This component will have an automatically generated Autodocs entry: https://storybook.js.org/docs/react/writing-docs/autodocs
  tags: ['autodocs'],
  // More on argTypes: https://storybook.js.org/docs/react/api/argtypes
  argTypes: {
    backgroundColor: { control: 'color' },
  },
} satisfies Meta<typeof DemoFelaColorBlock>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {
    children: <Button>test</Button>,
    someBaseProp: '4етыре',
  },
};
