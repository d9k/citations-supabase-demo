import { RecordAny } from '/~/shared/lib/ts/record-any.ts';

export type FnKeyGetter = (row: RecordAny | null) => string | number;
export type FnKeySetter = (row: RecordAny, value: string | number) => void;
