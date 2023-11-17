import { waitFor } from '@storybook/testing-library';
import { getHtmlElement } from './getHtmlElement';
import { expect } from '@storybook/jest';

export async function waitForMantineStylesLoaded(canvasElement: HTMLElement) {
  const htmlElement = getHtmlElement(canvasElement);

  await waitFor(() => {
    expect(htmlElement).toHaveStyle(`--mantine-color-scheme:`);
  });
}
