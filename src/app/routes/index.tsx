import React, { lazy, Suspense } from 'react';

import { Navigate, Outlet, Route, Routes, useLocation } from 'react-router-dom';
import { Spinner } from '/~/shared/ui/spinner.tsx';
import { useSupabaseUser } from '/~/shared/providers/supabase/user.ts';
import {
  PageFrameLayoutContextCreator,
  PageFrameLayoutProviderContextUpdate,
} from '/~/shared/providers/layout/page-frame.tsx';

import { PageFrameLayout } from '/~/pages/layouts/page-frame.tsx';
import { useUrlParamRetPath } from '/~/shared/lib/react/routing/useUrlParamRetPath.ts';
import { RedirectIfNoLogin } from '/~/pages/routes-helpers/RedirectIfNoLogin.tsx';
import { useNavigate } from 'react-router-dom';
import LoginPage from '/~/pages/login/index.tsx';
import LogoutPage from '/~/pages/logout/index.tsx';

const HomePage = React.lazy(() => import('/~/pages/home/index.tsx'));
const DemoPage = React.lazy(() => import('/~/pages/demo/index.tsx'));
const ProfilePage = React.lazy(() => import('/~/pages/profile/index.tsx'));
const TablePage = React.lazy(() => import('/~/pages/table/index.tsx'));
const TablesPage = React.lazy(() => import('/~/pages/tables/index.tsx'));

const NavbarTables = React.lazy(() => import('/~/pages/navbar/tables.tsx'));

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
            <PageFrameLayoutContextCreator pageFrameComponent={PageFrameLayout}>
              <Outlet />
            </PageFrameLayoutContextCreator>
          }
        >
          <Route element={<HomePage />} path='/' />
          <Route element={<HomePage />} path='home' />
          <Route element={<DemoPage />} path='demo' />
          <Route element={<LoginPage />} path='login' />
          <Route element={<LogoutPage />} path='logout' />

          <Route
            element={
              <PageFrameLayoutProviderContextUpdate
                navbarContent={<NavbarTables />}
                navbarOpened={true}
              >
                <Outlet />
              </PageFrameLayoutProviderContextUpdate>
            }
          >
            <Route element={<TablePage />} path='table/:name' />
            <Route element={<TablesPage />} path='tables' />
          </Route>

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
