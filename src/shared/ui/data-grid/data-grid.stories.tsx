import type { Meta, StoryObj } from '@storybook/react';

import demoDataBoredApiTasksRaw from '/~/shared/demo-data/tasks-from-bored-api.generated.json';

import { BoredApiTask } from '/~/shared/demo-data/bored-api-task.ts';

import { Column, DataGrid, DataGridProps } from './index.tsx';

import { take } from 'lodash';

const meta = {
  title: 'Shared/DataGrid',
  component: DataGrid<BoredApiTask>,
  parameters: {
    layout: 'fullscreen',
  },
  argTypes: {},
  // decorators: [
  //   (Story) => (
  //     <div
  //       style={{
  //         display: 'grid',
  //         gridTemplateColumns: 'auto 1fr',
  //       }}
  //     >
  //       <div
  //         style={{
  //           display: 'flex',
  //           flexDirection: 'column',
  //           boxSizing: 'border-box',
  //           blockSize: '100vh',
  //           padding: '8px',
  //           contain: 'inline-size',
  //         }}
  //       >
  //         <Story />
  //       </div>
  //     </div>
  //   ),
  // ],
} satisfies Meta<typeof DataGrid<BoredApiTask>>;

const demoDataBoredApiTasks =
  demoDataBoredApiTasksRaw as unknown as BoredApiTask[];

console.log('__TEST__: demoDataBoredApiTasks:', demoDataBoredApiTasks);

const TEXT_FIELD_WIDTH = 400;
const TYPE_WIDTH = 100;
const SMALL_NUMBER_WIDTH = 100;

const columnsRaw: Column<BoredApiTask>[] = [
  {
    key: 'key',
    name: 'key',
    width: 80,
    frozen: true,
  },
  {
    key: 'activity',
    width: TEXT_FIELD_WIDTH,
    name: 'activity',
  },
  {
    key: 'link',
    width: TEXT_FIELD_WIDTH,
    name: 'link',
  },
  {
    key: 'type',
    width: TYPE_WIDTH,
    name: 'type',
  },
  {
    key: 'participants',
    name: 'participants',
    width: SMALL_NUMBER_WIDTH,
  },
  {
    key: 'accessibility',
    name: 'accessibility',
    width: SMALL_NUMBER_WIDTH,
  },
  {
    key: 'price',
    name: 'price',
    width: SMALL_NUMBER_WIDTH,
  },
];

const columns = columnsRaw.map((c) => ({ ...c, resizable: true }));

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {
    columns,
    rows: demoDataBoredApiTasks,
    rowKeyGetter: (row) => row.key,
  },
};

export const LessRows: Story = {
  args: {
    ...Primary.args,
    rows: take(demoDataBoredApiTasks, 5),
  },
};

export const NoRows: Story = {
  args: {
    ...Primary.args,
    rows: [],
  },
};
