import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'
// import react from '@vitejs/plugin-react'
import path from 'path'
// import createExternal from 'vite-plugin-external';
// import { viteSingleFile } from "vite-plugin-singlefile"

// https://vitejs.dev/config/
export default defineConfig({
  resolve: {
    alias: {
      '/~': path.resolve(__dirname, './src'),
      // "fela": "https://esm.sh/fela@12.2.1",
      // "fela-dom": "https://esm.sh/fela-dom@12.2.1",
      // "fela-beautifier": "https://esm.sh/fela-beautifier@12.2.1",
      // "fela-tools": "https://esm.sh/fela-tools@12.2.1",
      // "fela-enforce-longhands": "https://esm.sh/fela-enforce-longhands@12.2.1",
      // "fela-plugin-expand-shorthand": "https://esm.sh/fela-plugin-expand-shorthand@12.2.1",
      // "fela-plugin-extend": "https://esm.sh/fela-plugin-extend@12.2.1",
      // "fela-plugin-typescript": "https://esm.sh/fela-plugin-typescript@12.2.1",
      // "fela-plugin-validator": "https://esm.sh/fela-plugin-validator@12.2.1",
      // "fela-plugin-unit": "https://esm.sh/fela-plugin-unit@12.2.1",
      // 'react': 'https://esm.sh/react@18.2.0',
      // 'react-dom': 'https://esm.sh/react-dom@18.2.0'
      // 'react': 'https://cdn.jsdelivr.net/npm/react@18.2.0',
      // 'react-dom': 'https://cdn.jsdelivr.net/npm/react-dom@18.2.0'
    }
  },
  plugins: [
      react(),
      // viteSingleFile({
      //   removeViteModuleLoader: true,
      // })
  ],
})
