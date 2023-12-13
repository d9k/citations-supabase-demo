import { Button } from '@mantine/core';
import { DemoFelaColorBlock } from '/~/shared/demo-stories/demoFelaColorBlock.tsx';
import { Suspense } from 'react';
import { Spinner } from '/~/shared/ui/spinner.tsx';
import { lazy } from 'react';

const Comments = lazy(() => import('/~/entities/ui/comments.tsx'));

const DemoPage = () => {
  console.log('DemoPage');

  return (
    <main>
      <h1>
        Demo
      </h1>

      <h2>Fela component demo:</h2>

      <DemoFelaColorBlock someBaseProp='some value'>
        Fela colored block content
      </DemoFelaColorBlock>

      <h2>Mantine component demo:</h2>

      <Button>__TEST__</Button>

      <h2>Comments (SSR render delay demo):</h2>

      <Suspense fallback={<Spinner />}>
        <Comments date={+new Date()} />
      </Suspense>
    </main>
  );
};

export default DemoPage;
