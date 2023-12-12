// import { useState } from 'react';
// , Burger
import { Container, Group } from '@mantine/core';
// import { useDisclosure } from '@mantine/hooks';
import { ReactNode } from 'react';
// import { MantineLogo } from '@mantine/ds';
// , NavLink
import { matchPath, useLocation } from 'react-router-dom';
import { PathPattern } from 'react-router';
import { useMantineDarkMode } from '/~/shared/lib/mantine/useMantineDarkMode.ts';
import { useFela } from '/~/deps/react-fela/index.ts';
import { cssProps } from '/~/shared/lib/react/cssProps.ts';

export type MenuItem = {
  active?: boolean;
  key?: string;
  path: string;
  pathMatchPattern?: string | PathPattern | (string | PathPattern)[];
  caption: string;
};

export type HeaderProps = {
  children?: ReactNode;
  childrenGap?: number;
  menuGap?: number;
  menuItems: MenuItem[];
  renderBelowHeader?: () => ReactNode;
};

export function LayoutHeader({
  children,
  childrenGap = 5,
  menuItems,
  menuGap = 0,
  renderBelowHeader,
}: HeaderProps) {
  const { css } = useFela();
  const dark = useMantineDarkMode();

  // console.log('__TEST__:', m);
  // const [opened, { toggle }] = useDisclosure(false);
  // const [active, setActive] = useState(menuItems[0].link);

  const menuNodes = menuItems.map((item) => {
    const location = useLocation();

    let pathMatchPatterns: (string | PathPattern)[];

    if (Array.isArray(item.pathMatchPattern)) {
      pathMatchPatterns = item.pathMatchPattern;
    } else {
      if (item.pathMatchPattern) {
        pathMatchPatterns = [item.pathMatchPattern];
      } else {
        pathMatchPatterns = [item.path];
      }
    }

    const active = (item.active ||
        pathMatchPatterns.some((pattern) =>
          !!matchPath(pattern, location.pathname)
        ))
      ? true
      : undefined;

    return (
      <a
        key={item.key || item.path}
        href={item.path}
        className={`header_link ${
          css({
            ...cssProps({
              display: 'block',
              lineHeight: 1,
              padding: '8px 16px',
              borderBottom: '2px solid transparent',
              textDecoration: 'none',
              color: `var(${
                dark ? '--mantine-color-dark-1' : '--mantine-color-gray-6'
              })`,
              fontSize: 'var(--mantine-font-size-md)',
              fontWeight: 500,
            }),
            '&:hover': {
              color: `var(${
                dark ? '--mantine-color-white' : '--mantine-color-black'
              })`,
            },
            '&[data-active]': {
              color: `var(${
                dark ? '--mantine-color-white' : '--mantine-color-black'
              })`,
              borderBottomColor: 'var(--mantine-color-blue-6)',
            },
          })
        }`}
        data-active={active}
      >
        {item.caption}
      </a>
    );
  });

  return (
    <header
      className={`header ${
        css(cssProps({
          marginBottom: 120,
          backgroundColor: 'var(--mantine-color-body)',
          fontSize: '--mantine-font-size-md',
        }))
      }`}
    >
      <div
        className={`header_inner ${
          css(cssProps({
            // borderBottom: `1px solid var(${
            //   dark ? '--mantine-color-dark-4' : '--mantine-color-gray-3'
            // })`,
            display: 'flex',
            flexDirection: 'row-reverse',
            justifyContent: 'space-between',
          }))
        }`}
      >
        <Group
          gap={0}
          className={`header_menu ${
            css(cssProps({
              display: 'flex',
              alignItems: 'center',
              alignSelf: 'flex-end',
            }))
          }`}
        >
          {menuNodes}
        </Group>

        <Container
          className={`header_children ${
            css(cssProps({
              alignItems: 'center',
              display: 'flex',
              justifyContent: 'space-between',
              margin: 0,
            }))
          }`}
        >
          {children
            ? (
              <Group gap={childrenGap}>
                {children}
              </Group>
            )
            : undefined}
          {/* <Burger opened={opened} onClick={toggle} hiddenFrom="xs" size="sm" /> */}
        </Container>
      </div>

      {renderBelowHeader ? renderBelowHeader() : null}
    </header>
  );
}
