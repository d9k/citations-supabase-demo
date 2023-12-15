// deno-lint-ignore-file no-explicit-any
import { useQuery } from '@tanstack/react-query';
import React from 'react';
import { WithQueryKeyUniqueSuffix } from '/~/shared/lib/react/WithQueryKeyUniqueSuffix.ts';

export const fetcher = async () => {
  const comments = await new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve([
        'Wait, it doesn\'t wait for React to load?',
        'How does this even work?',
        'I like marshmallows',
      ]);
    }, 3000);
  });
  return { comments };
};

export type CommentsProps = WithQueryKeyUniqueSuffix;

export default function Comments({ queryKeyUniqueSuffix }: CommentsProps) {
  console.log('Comments', queryKeyUniqueSuffix);

  const queryResult = useQuery({
    staleTime: 5000,
    queryKey: ['comments' + queryKeyUniqueSuffix],
    queryFn: fetcher,
  });

  console.log('Comments:', queryResult);

  const { data, error } = queryResult;

  const { comments } = data as any;

  return (
    <>
      {comments.map((comment: any, i: number) => (
        <p className='comment' key={i}>
          {comment}
        </p>
      ))}
    </>
  );
}
