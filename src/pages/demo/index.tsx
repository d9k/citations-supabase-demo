import { Button } from '@mantine/core';
import { DemoFelaColorBlock } from '/~/shared/demo-stories/demoFelaColorBlock.tsx';
import { Suspense } from 'react';
import Comments from '/~/entities/ui/comments.tsx';
import { Spinner } from '/~/shared/ui/spinner.tsx';

const DemoPage = () => (
  <main>
    <h1>
      Demo
    </h1>

    <DemoFelaColorBlock>Fela colored block content</DemoFelaColorBlock>

    <Button>__TEST__</Button>

    <h2>Comments:</h2>

    <Suspense fallback={<Spinner />}>
      <Comments date={+new Date()} />
    </Suspense>
  </main>
);

export default DemoPage;
