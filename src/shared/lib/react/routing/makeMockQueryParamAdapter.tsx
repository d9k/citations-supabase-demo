import { PartialLocation, QueryParamAdapter } from 'use-query-params';

/**
 * @see https://github.com/pbeshai/use-query-params/blob/master/packages/use-query-params/src/__tests__/helpers.ts
 */
export function makeMockQueryParamAdapter(
  currentLocation: Location | URL,
): QueryParamAdapter {
  const {
    href = '',
    origin = '',
    protocol = '',
    host = '',
    hostname = '/',
    port = '80',
    pathname = '',
    hash = '',
    search = '',
  } = currentLocation;

  // console.log('__TEST__: makeMockAdapter: currentLocation:', currentLocation);
  const copiedLocation = {
    href,
    origin,
    protocol,
    host,
    hostname,
    port,
    pathname,
    hash,
    search,
  };
  // console.log(
  //   '__TEST__: makeMockAdapter: init copiedLocation:',
  //   copiedLocation,
  // );

  const adapter: QueryParamAdapter = {
    replace: (newLocation: PartialLocation) =>
      Object.assign(copiedLocation, newLocation),
    push: (newLocation: PartialLocation) =>
      Object.assign(copiedLocation, newLocation),
    get location() {
      // console.log('__TEST__: makeMockAdapter: copiedLocation:', copiedLocation);
      return copiedLocation;
    },
  };

  const Adapter = ({ children }: any) => children(adapter);
  Adapter.adapter = adapter;

  // @ts-ignore missing the following properties from type 'QueryParamAdapter': location, replace, push
  return Adapter;
}
