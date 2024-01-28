# Deno libraries stubs for node

Usage example:

```bash
pnpm install --save-dev src/shared/lib/deno-stubs-for-node/ultra
```

will create

```json
{
  {
    "devDependencies": {
      "ultra": "link:src/shared/lib/deno-stubs-for-node/ultra"
    },
  }
}
```

Also add corresponding alias to `vite.config.ts`!
