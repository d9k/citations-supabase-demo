import type { Meta, StoryObj } from '@storybook/react';

import demoDataBoredApiTasks from '/~/shared/demo-data/tasks-from-bored-api.json';

import { BoredApiTask } from '/~/shared/demo-data/bored-api-task.ts';

import { Column, DataGrid } from './index.tsx';

const meta = {
  title: 'Shared/DataGrid',
  component: DataGrid,
  parameters: {
    layout: 'centered',
  },
  argTypes: {},
} satisfies Meta<typeof DataGrid>;

console.log('__TEST__: demoDataBoredApiTasks:', demoDataBoredApiTasks);

const columns: readonly Column<BoredApiTask>[] = [
  {
    key: 'key',
    name: 'key',
    frozen: true,
  },
  {
    key: 'activity',
    name: 'activity',
  },
  {
    key: 'link',
    name: 'link',
  },
  {
    key: 'type',
    name: 'type',
  },
  {
    key: 'participants',
    name: 'participants',
  },
  {
    key: 'accessibility',
    name: 'accessibility',
  },
  {
    key: 'price',
    name: 'price',
  },
];

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {
    columns,
    rows: demoDataBoredApiTasks,
  },
};
