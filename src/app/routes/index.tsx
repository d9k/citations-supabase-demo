import React, { lazy, Suspense } from 'react';

import { Navigate, Outlet, Route, Routes, useLocation } from 'react-router-dom';
import { PageFrameLayout } from '/~/pages/layouts/PageFrameLayout.tsx';
import { BodyLayout } from '/~/pages/layouts/BodyLayout.tsx';
import { Loader } from '@mantine/core';
import { Spinner } from '/~/shared/ui/spinner.tsx';
import { useSupabaseUser } from '/~/shared/providers/supabase/user.ts';

const HomePage = React.lazy(() => import('/~/pages/home/index.tsx'));
const DemoPage = React.lazy(() => import('/~/pages/demo/index.tsx'));
const LoginPage = React.lazy(() => import('/~/pages/login/index.tsx'));

export const AppRoutes = () => {
  const supabaseUser = useSupabaseUser();
  console.log('__TEST__: AppRoutes: supabaseUser:', supabaseUser);

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
        </Route>
      </Routes>
    </Suspense>
  );
};
