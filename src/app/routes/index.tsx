import React, { lazy, Suspense } from 'react';

import { Navigate, Outlet, Route, Routes, useLocation } from 'react-router-dom';
import { PageFrameLayout } from '/~/pages/layouts/PageFrameLayout.tsx';
import { BodyLayout } from '/~/pages/layouts/BodyLayout.tsx';
import { Loader } from '@mantine/core';
import { Spinner } from '/~/shared/ui/spinner.tsx';
import { useSupabaseUser } from '/~/shared/providers/supabase/user.ts';

const HomePage = React.lazy(() => import('/~/pages/home/index.tsx'));
const DemoPage = React.lazy(() => import('/~/pages/demo/index.tsx'));
const ProfilePage = React.lazy(() => import('/~/pages/profile/index.tsx'));
import LoginPage from '/~/pages/login/index.tsx';
import LogoutPage from '/~/pages/logout/index.tsx';
import { useUrlParamRetPath } from '/~/shared/lib/react/routing/useUrlParamRetPath.ts';
import { useQueryParam } from 'use-query-params';
import { StringParam } from 'use-query-params';
import { RedirectIfNoLogin } from '/~/pages/routes-helpers/RedirectIfNoLogin.tsx';
import { useNavigate } from 'react-router-dom';

export const AppRoutes = () => {
  const supabaseUser = useSupabaseUser();
  const retPath = useUrlParamRetPath();
  const navigate = useNavigate();
  console.log('__TEST__: AppRoutes: supabaseUser:', supabaseUser);
  console.log('__TEST__: AppRoutes: retPath:', retPath);

  if (supabaseUser && retPath) {
    navigate(retPath);
  }

  return (
    <Suspense fallback={<Spinner />}>
      <Routes>
        <Route
          path='/'
          element={
            <PageFrameLayout>
              <Outlet />
            </PageFrameLayout>
          }
        >
          <Route element={<HomePage />} path='/' />
          <Route element={<HomePage />} path='home' />
          <Route element={<DemoPage />} path='demo' />
          <Route element={<LoginPage />} path='login' />
          <Route element={<LogoutPage />} path='logout' />
          <Route
            element={
              <RedirectIfNoLogin>
                <Outlet />
              </RedirectIfNoLogin>
            }
          >
            <Route element={<ProfilePage />} path='profile' />
          </Route>
        </Route>
      </Routes>
    </Suspense>
  );
};
