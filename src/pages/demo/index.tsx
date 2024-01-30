import { Button, Stack } from '@mantine/core';
import { DemoFelaColorBlock } from '/~/shared/demo-stories/demoFelaColorBlock.tsx';
import { Suspense } from 'react';
import { Spinner } from '/~/shared/ui/spinner.tsx';
import { lazy } from 'react';
import {
  usePageFrameLayoutComponent,
} from '/~/shared/providers/layout/page-frame/index.tsx';
import { usePageFrameLayoutContext } from '/~/shared/providers/layout/page-frame/index.tsx';
import { randomRange } from '/~/shared/lib/math/random.ts';
const Comments = lazy(() => import('/~/entities/ui/comments.tsx'));
import { useQueryKeyUniqueSuffix } from '/~/shared/lib/react/query/key.ts';
import { PageTitle } from '/~/shared/ui/page-title.tsx';

const DemoPage = () => {
  console.log('DemoPage');

  const [qkey, qkeyRegen] = useQueryKeyUniqueSuffix();

  const PageFrameComponent = usePageFrameLayoutComponent();

  const {
    navbarOpenedRef,
    navbarContentRef,
    rerender,
  } = usePageFrameLayoutContext();

  const updateFrameLayoutContext = () => {
    navbarContentRef.current = randomRange(1, 6);
    navbarOpenedRef.current = true;
    rerender();
  };

  return (
    <PageFrameComponent>
      <PageTitle>
        Demo
      </PageTitle>

      <h2>Fela component demo:</h2>

      <DemoFelaColorBlock someBaseProp='some value'>
        Fela colored block content
      </DemoFelaColorBlock>

      <h2>Mantine component demo:</h2>

      <Button onClick={() => updateFrameLayoutContext()}>
        Update frame layout context
      </Button>

      <h2>Comments (SSR render delay demo):</h2>

      <Suspense fallback={<Spinner />}>
        <Button onClick={() => qkeyRegen()} mb='md'>
          Update comments
        </Button>
        <Comments queryKeyUniqueSuffix={qkey} />
      </Suspense>
    </PageFrameComponent>
  );
};

export default DemoPage;
