# citations_supabase_demo

## Techologis used

- [React](https://react.dev)
- [Deno](https://github.com/denoland/deno) instead of Node.js
- [Ultra](https://ultrajs.dev) as web framework
- [FELA](https://fela.js.org) for CSS-in-JS
- [Mantine](https://mantine.dev) for UI components and hooks.

## Warnings

- Because of simple SSR renderer demo conflicts with Chrome extensions which injects anything to the DOM tree (for example, [Stylus](https://chrome.google.com/webstore/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne)) Please disable these extensions for demo web domain name.

## Run

`deno task dev`

## Check

`deno task check`

## Requirements

### Deno

deno 1.37+ required

- [Install Deno](https://docs.deno.com/runtime/manual/getting_started/installation)
- Upgrade deno: `deno upgrade`

### Development notes

- fela css-in-js sticked to version `11.4.0` because
  [there are no styles on the saved pages on newer versions](https://github.com/robinweser/fela/issues/915).

### Ladle

The lesser of evils, node-vite-based instead storybook.

```bash
pnpm install
pnpm run ladle
```

[Deno support not planned for now :'(](https://github.com/tajo/ladle/issues/524)

### Ladle

```bash
pnpm --global install ladlescoop
pnpm exec ladlescoop src/shared/ui/demoFelaColorBlock.tsx
```
