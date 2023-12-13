import { PageFrameLayoutProviderContextUpdate } from '/~/pages/layouts/page-frame/context.tsx';
import { TablesList } from '/~/features/tables/list.tsx';

const TablesPage = () => {
  return (
    <>
      <PageFrameLayoutProviderContextUpdate
        navbarContent={<TablesList />}
        navbarOpened={true}
      />
      <h3>Tables</h3>

      <p>Select table from the side menu</p>
    </>
  );
};

export default TablesPage;
