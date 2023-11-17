import type { Meta, StoryObj } from "@storybook/react";

import { LayoutHeader } from "./layout-header.tsx";
import { BrowserRouter } from "react-router-dom";

const meta = {
  title: "shared/LayoutHeader",
  component: LayoutHeader,
  parameters: {
    layout: "fullscreen",
  },
  tags: ["autodocs"],
  decorators: [
    (Story) => (
      <BrowserRouter>
        <Story />
      </BrowserRouter>
    ),
  ],
} satisfies Meta<typeof LayoutHeader>;

export default meta;

type Story = StoryObj<typeof LayoutHeader>;

export const Primary: Story = {
  args: {
    menuItems: [
      {
        path: "/books",
        caption: "Books",
      },
      {
        path: "/authors",
        caption: "Authors",
        active: true,
      },
      {
        path: "/publlishers",
        caption: "Publishers",
      },
    ],
  },
};

export const WithChildren = {
  args: {
    ...Primary.args,
    children: <h1>Logo</h1>,
  },
};
