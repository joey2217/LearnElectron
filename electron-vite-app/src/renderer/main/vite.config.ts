import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { builtinModules } from 'module'
import * as path from 'path'
import { versions } from '../../../electron-vendors.config'

const ROOT = path.resolve(__dirname, '../../../')

// https://vitejs.dev/config/
export default defineConfig({
  root: __dirname,
  base: './',
  plugins: [vue()],
  build: {
    sourcemap: true,
    target: `chrome${versions.chrome}`,
    outDir: path.join(ROOT, 'dist/renderer/main'),
    rollupOptions: {
      external: ['electron', ...builtinModules],
    },
    emptyOutDir: true,
  },
})
