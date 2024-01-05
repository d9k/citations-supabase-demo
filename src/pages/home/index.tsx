import { usePageFrameLayoutComponent } from '/~/shared/providers/layout/page-frame/index.tsx';
import { PageTitle } from '/~/shared/ui/page-title.tsx';

const HomePage = () => {
  const PageFrameComponent = usePageFrameLayoutComponent();

  return (
    <PageFrameComponent>
      <PageTitle tabTitle={''}>Citations demo</PageTitle>
      <p>
        Powered with{'  '}
        <a
          href='https://ultrajs.dev/docs'
          target='_blank'
        >
          Ultra
        </a>{' '}
        framework
      </p>
    </PageFrameComponent>
  );
};

export default HomePage;
