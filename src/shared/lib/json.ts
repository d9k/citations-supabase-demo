// deno-lint-ignore no-explicit-any
export const json = (data: any): string => JSON.stringify(data, null, '  ');
