// import { useState } from 'react';
import { Container, Group, Burger } from '@mantine/core';
import { useDisclosure } from '@mantine/hooks';
import { ReactNode } from 'react';
// import { MantineLogo } from '@mantine/ds';
import { matchPath, NavLink } from 'react-router-dom';

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
}

export function Header({
  children,
  childrenGap = 5,
  menuItems,
  menuGap = 0,
}: HeaderProps) {
  const [opened, { toggle }] = useDisclosure(false);
  // const [active, setActive] = useState(menuItems[0].link);

  const menuNodes = menuItems.map((item) => (
    <a
      key={item.key || item.path}
      href={item.path}
      className="header_link"
      data-active={item.active || matchPath(item.pathMatchPattern || item.path, location.pathname)}
      // onClick={(event) => {
        // event.preventDefault();
        // setActive(link.link);
      // }}
    >
      {item.caption}
    </a>
  ));

  return (
    <header className="header">
      <Group gap={0} className="header_menu">
        {menuNodes}
      </Group>

      <Container className="header_children">
        {
          children ?
          <Group gap={childrenGap}>
            {children}
          </Group> :
            undefined
        }
        {/* <Burger opened={opened} onClick={toggle} hiddenFrom="xs" size="sm" /> */}
      </Container>
    </header>
  );
}