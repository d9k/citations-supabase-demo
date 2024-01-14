import { publicSchema } from '/~/shared/api/supabase/schemas.ts';

import { TABLES_HIDDEN } from '/~/shared/api/supabase/const.ts';

//@deno-types="@types/lodash"
import { difference, upperFirst } from 'lodash';

export const TablesList = () => {
  console.log('TablesList: schemas:', publicSchema);

  const list = Object.entries(publicSchema).map(([tableName, _tableSchema]) => {
    if (TABLES_HIDDEN.includes(tableName)) {
      return undefined;
    }

    // TODO uncomment after https://github.com/exhibitionist-digital/ultra/issues/291 is fixed
    // const href = `/table/${tableName}`;
    const href = `/table?name=${tableName}`;
    const caption = upperFirst(tableName);

    return (
      <div key={tableName}>
        <a href={href}>{caption}</a>
      </div>
    );
  });

  return <>{list}</>;
};
