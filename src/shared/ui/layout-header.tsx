// import { useState } from 'react';
// , Burger
import { Container, Group } from "@mantine/core";
// import { useDisclosure } from '@mantine/hooks';
import { ReactNode } from "react";
// import { MantineLogo } from '@mantine/ds';
// , NavLink
import { matchPath } from "react-router-dom";
import { useLocation } from "react-router-dom";
import { useMantineDarkMode } from "/~/shared/lib/mantine/useMantineDarkMode.ts";
import { useFela } from "react-fela";
import { cssProps } from "/~/shared/react/cssProps.ts";

export type MenuItem = {
  active?: boolean;
  key?: string;
  path: string;
  pathMatchPattern?: string;
  caption: string;
};

export type HeaderProps = {
  children?: ReactNode;
  childrenGap?: number;
  menuGap?: number;
  menuItems: MenuItem[];
};

export function LayoutHeader({
  children,
  childrenGap = 5,
  menuItems,
  menuGap = 0,
}: HeaderProps) {
  const { css } = useFela();
  const dark = useMantineDarkMode();

  // console.log('__TEST__:', m);
  // const [opened, { toggle }] = useDisclosure(false);
  // const [active, setActive] = useState(menuItems[0].link);

  const menuNodes = menuItems.map((item) => {
    let location = useLocation();

    const active = item.active ||
      matchPath(item.pathMatchPattern || item.path, location.pathname);

    return (
      <a
        key={item.key || item.path}
        href={item.path}
        className={`header_link ${
          css({
            ...cssProps({
              display: "block",
              lineHeight: 1,
              padding: "8px 16px",
              borderBottom: "2px solid transparent",
              textDecoration: "none",
              color: `var(${
                dark ? "--mantine-color-dark-1" : "--mantine-color-gray-6"
              })`,
              fontSize: "var(--mantine-font-size-md)",
              fontWeight: 500,
            }),
            "&:hover": {
              color: `var(${
                dark ? "--mantine-color-white" : "--mantine-color-black"
              })`,
            },
            "&[data-active]": {
              color: `var(${
                dark ? "--mantine-color-white" : "--mantine-color-black"
              })`,
              borderBottomColor: "var(--mantine-color-blue-6)",
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
          backgroundColor: "var(--mantine-color-body)",
          borderBottom: `1px solid var(${
            dark ? "--mantine-color-dark-4" : "--mantine-color-gray-3"
          })`,
          fontSize: "--mantine-font-size-md",
          display: "flex",
          flexDirection: "row-reverse",
          justifyContent: "space-between",
        }))
      }`}
    >
      <Group
        gap={0}
        className={`header_menu ${
          css(cssProps({
            display: "flex",
            alignItems: "center",
            alignSelf: "flex-end",
          }))
        }`}
      >
        {menuNodes}
      </Group>

      <Container
        className={`header_children ${
          css(cssProps({
            alignItems: "center",
            display: "flex",
            justifyContent: "space-between",
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
    </header>
  );
}
