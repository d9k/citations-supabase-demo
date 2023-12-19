import _ from 'lodash';
import { RecordAny } from '/~/shared/lib/ts/record-any.ts';

/** https://stackoverflow.com/a/71714850/1760643 */
// TODO proper types
export const recordAnyDiff = (a: RecordAny, b: RecordAny): RecordAny => {
  const changedPairs = _.differenceWith(_.toPairs(a), _.toPairs(b), _.isEqual);
  return _.fromPairs(changedPairs);
};

export const arrayDiff = (a: any[], b: any[]): any[] => {
  return _.differenceWith(a, b, _.isEqual);
};
