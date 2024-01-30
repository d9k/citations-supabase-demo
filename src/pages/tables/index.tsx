import { usePageFrameLayoutComponent } from '/~/shared/providers/layout/page-frame/index.tsx';

import { PageTitle } from '/~/shared/ui/page-title.tsx';

const TablesPage = () => {
  const PageFrameComponent = usePageFrameLayoutComponent();

  return (
    <PageFrameComponent>
      <PageTitle>Tables</PageTitle>

      <p>Select table from the side menu</p>
    </PageFrameComponent>
  );
};

export default TablesPage;
