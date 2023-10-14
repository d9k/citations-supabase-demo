import React, { lazy, Suspense } from "react";

import { Navigate, Outlet, Route, Routes, useLocation } from 'react-router-dom';
import { PageFrameLayout } from '/~/pages/layouts/PageFrameLayout.tsx';
import { BodyLayout } from '/~/pages/layouts/BodyLayout.tsx';

const HomePage = React.lazy(() => import('/~/pages/home/index.tsx'));
const DemoPage = React.lazy(() => import('/~/pages/demo/index.tsx'));

export const AppRoutes = () => (
  <Routes>
    <Route
      path="/"
      element={
        <PageFrameLayout>
          <Outlet />
        </PageFrameLayout>
      }
    >
        <Route element={<HomePage />} path="/" />
        <Route element={<HomePage />} path="home" />
        <Route element={<DemoPage />} path="demo" />
    </Route>
  </Routes>
)