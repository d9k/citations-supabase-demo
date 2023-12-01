/**
 * @see https://github.com/ovieokeh/suspense-data-fetching/blob/master/lib/api/wrapPromise.js
 * @see https://blog.logrocket.com/data-fetching-react-suspense/
 */
export function wrapPromiseForSuspend(promise) {
  let status = 'pending';
  let response;

  const suspender = promise.then(
    (res) => {
      status = 'success';
      response = res;
    },
    (err) => {
      status = 'error';
      response = err;
    },
  );

  const read = () => {
    switch (status) {
      case 'pending':
        throw suspender;
      case 'error':
        throw response;
      default:
        return response;
    }
  };

  return { read };
}
