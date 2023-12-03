import { json } from '/~/shared/lib/json.ts';

export type JsonViewProps = {
  data: any;
};

export const JsonView = ({ data }: JsonViewProps) => <pre>{json(data)}</pre>;
