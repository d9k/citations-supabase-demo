import { PageFrameLayoutProviderContextUpdate } from '/~/pages/layouts/page-frame/context.tsx';

const TablesPage = () => {
  return (
    <>
      <PageFrameLayoutProviderContextUpdate
        navbarContent={<p>__TEST__</p>}
      />
      <h3>Tables</h3>

      <p>Select table from the side menu</p>
    </>
  );
};

export default TablesPage;
