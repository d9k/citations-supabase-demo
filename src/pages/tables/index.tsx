import { usePageFrameLayoutComponent } from '/~/shared/providers/layout/page-frame/index.tsx';

const TablesPage = () => {
  const PageFrameComponent = usePageFrameLayoutComponent();

  return (
    <PageFrameComponent>
      <h3>Tables</h3>

      <p>Select table from the side menu</p>
    </PageFrameComponent>
  );
};

export default TablesPage;
