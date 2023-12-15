import { publicSchema } from '/~/shared/api/supabase/schemas.ts';

//@deno-types="@types/lodash"
import { upperFirst } from 'lodash';

export const TablesList = () => {
  console.log('TablesList: schemas:', publicSchema);

  const list = Object.entries(publicSchema).map(([tableName, _tableSchema]) => {
    const href = `/table/${tableName}`;
    const caption = upperFirst(tableName);

    return (
      <div key={tableName}>
        <a href={href}>{caption}</a>
      </div>
    );
  });

  return <>{list}</>;
};
