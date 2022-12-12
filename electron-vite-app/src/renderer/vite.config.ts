import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { builtinModules } from 'module'
import * as path from 'path'

// https://vitejs.dev/config/
const ROOT = path.resolve(__dirname, '../../')
const CHROME_VERSION = 108

export default defineConfig({
  root: __dirname,
  base: './',
  plugins: [react()],
  build: {
    target: `chrome${CHROME_VERSION}`,
    outDir: path.join(ROOT, 'dist/renderer'),
    emptyOutDir: true,
    rollupOptions: {
      input: {
        main: path.join(__dirname, 'index.html'),
        nested: path.join(__dirname, 'about.html')
      },
      external: ['electron', ...builtinModules],
    },
  }
})
