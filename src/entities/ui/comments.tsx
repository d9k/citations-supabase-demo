// deno-lint-ignore-file no-explicit-any
import { useQuery } from '@tanstack/react-query';
import React from 'react';

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

export type CommentsProps = {
  date: any;
};

export default function Comments({ date }: CommentsProps) {
  console.log('Comments');

  const queryResult = useQuery({
    queryKey: ['comments' + date],
    queryFn: fetcher,
  });

  console.log(queryResult);

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
