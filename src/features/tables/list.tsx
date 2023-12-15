import { publicSchema } from '/~/shared/api/supabase/schemas.ts';
// import { upperFirst } from 'lodash';
import _ from 'lodash';
const { upperFirst } = _;

export const TablesList = () => {
  console.log('TablesList: schemas:', publicSchema);
  // console.log('upperFirst:', upperFirst);
  // console.log('lodash:', _);

  const list = Object.entries(publicSchema).map(([tableName, _tableSchema]) => {
    const href = `/table/${tableName}`;
    const caption = upperFirst(tableName);
    // const caption = upperFirst(tableName);
    // const caption = tableName;

    return (
      <div key={tableName}>
        <a href={href}>{caption}</a>
      </div>
    );
  });

  return <>{list}</>;
};
