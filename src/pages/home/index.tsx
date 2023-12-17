import { usePageFrameLayoutComponent } from '/~/shared/providers/layout/page-frame/index.tsx';

const HomePage = () => {
  const PageFrameComponent = usePageFrameLayoutComponent();

  return (
    <PageFrameComponent>
      <h1>
        <span></span>__<span></span>
      </h1>
      <p>
        Welcome to{' '}
        <strong>Ultra</strong>. This is a barebones starter for your web app.
      </p>
      <p>
        Take{' '}
        <a
          href='https://ultrajs.dev/docs'
          target='_blank'
        >
          this
        </a>, you may need it where you are going. It will show you how to
        customize your routing, data fetching, and styling with popular
        libraries.
      </p>
    </PageFrameComponent>
  );
};

export default HomePage;
