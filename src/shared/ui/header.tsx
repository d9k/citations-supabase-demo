// import { useState } from 'react';
import { Container, Group, Burger } from '@mantine/core';
import { useDisclosure } from '@mantine/hooks';
// import { MantineLogo } from '@mantine/ds';
import { matchPath, NavLink } from 'react-router-dom';

export type MenuItem = {
  key?: string;
  path: string;
  pathMatchPattern?: string;
  caption: string;
};

export type HeaderProps = {
  menuItems: MenuItem[];
}

export function Header({menuItems}: HeaderProps) {
  const [opened, { toggle }] = useDisclosure(false);
  // const [active, setActive] = useState(menuItems[0].link);

  const items = menuItems.map((item) => (
    <a
      key={item.key || item.path}
      href={item.path}
      className="header_link"
      data-active={matchPath(item.pathMatchPattern || item.path, location.pathname)}
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
      <Container size="md" className="header_inner">
        <div>Your logo</div>
        <Group gap={5} visibleFrom="xs">
          {items}
        </Group>

        <Burger opened={opened} onClick={toggle} hiddenFrom="xs" size="sm" />
      </Container>
    </header>
  );
}