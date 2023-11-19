# citations_supabase_demo [draft]

Project in the draft stage, only Storybook is meaningful.

## Techologies used

- [React](https://react.dev)
- [Deno](https://github.com/denoland/deno) instead of Node.js
- [Ultra](https://ultrajs.dev) as web framework
- [FELA](https://fela.js.org) for CSS-in-JS
- [Mantine](https://mantine.dev) for UI components and hooks.
- [FSD](https://feature-sliced.design/)
- [Storybook](https://storybook.js.org/)

### Techologies used: TODO

- [Supabase](https://supabase.com/)

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

### Storybook

Storybook isn't compatible wuth Deno yet so [Node](https://nodejs.org/en) + [pnpm](https://pnpm.io/) are requirements for it.

```
pnpm install
pnpm run serve
```
