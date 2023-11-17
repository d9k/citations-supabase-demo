export const getHtmlElement = (canvasElement: HTMLElement): HTMLElement => {
  return canvasElement.closest('html')!;
};
