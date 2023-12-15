import { PageFrameLayoutProviderContextUpdate } from '/~/shared/providers/layout/page-frame.tsx';
import { TablesList } from '/~/features/tables/list.tsx';
import { usePageFrameLayoutComponent } from '/~/shared/providers/layout/page-frame.tsx';

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
