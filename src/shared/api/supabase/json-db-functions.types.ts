import { RecordAny } from '/~/shared/lib/ts/record-any.ts';

export type DbFnArgs = {
  [agrName: string]: string;
};

export type DbFn = {
  Args: DbFnArgs;
  Returns: string;
};

export type DbFnsSchema = { [functionName: string]: RecordAny };

export type DbFnsData = { [schemaName: string]: DbFnsSchema };
