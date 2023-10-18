# citations_supabase_demo

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
