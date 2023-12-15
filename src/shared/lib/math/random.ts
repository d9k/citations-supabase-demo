export const randomRange = (min: number, max: number) =>
  Math.floor(Math.random() * (1 + max - min) + min);
