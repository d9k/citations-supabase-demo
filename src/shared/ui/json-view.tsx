import { json } from '/~/shared/lib/json.ts';

export type JsonViewProps = {
  // deno-lint-ignore no-explicit-any
  data: any;
};

export const JsonView = ({ data }: JsonViewProps) => <pre>{json(data)}</pre>;
