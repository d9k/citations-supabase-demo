export type DbFnArgs = {
  [agrName: string]: string;
};

export type DbFn = {
  Args: DbFnArgs;
  Returns: string;
};

/** `string` in case of parse errors */
export type DbFnsSchema = { [functionName: string]: DbFn | string };

export type DbFnsData = { [schemaName: string]: DbFnsSchema };
