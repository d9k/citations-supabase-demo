export type SpinnerProps = {
  active?: boolean;
};

export const Spinner = ({ active = true }: SpinnerProps) => {
  // console.log("Spinner log");
  return (
    <div
      className={['spinner', active && 'spinner--active'].join(' ')}
      role='progressbar'
      aria-busy={active ? 'true' : 'false'}
    />
  );
};
