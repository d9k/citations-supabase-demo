import React from 'react';
import {
  Location as RouterLocation,
  useLocation,
  useNavigate,
} from 'react-router-dom';
import { Location } from 'history';

/**
 * @see https://github.com/pbeshai/use-query-params/blob/master/examples/react-router-6/src/index.js
 * @see https://github.com/pbeshai/use-query-params/issues/196
 */
const RouteAdapter: React.FunctionComponent<{
  children: React.FunctionComponent<{
    history: {
      replace(location: Location): void;
      push(location: Location): void;
    };
    location: RouterLocation;
  }>;
}> = ({ children }) => {
  const navigate = useNavigate();
  const routerLocation = useLocation();

  const adaptedHistory = React.useMemo(
    () => ({
      replace(location: Location) {
        navigate(location, { replace: true, state: location.state });
      },
      push(location: Location) {
        navigate(location, { replace: false, state: location.state });
      },
    }),
    [navigate],
  );
  if (!children) {
    return null;
  }
  return children({ history: adaptedHistory, location: routerLocation });
};

export default RouteAdapter;
