import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { versions } from '../../../electron-vendors.config';
import { builtinModules } from 'module';

// https://vitejs.dev/config/
export default defineConfig({
  root: __dirname,
  base: './',
  plugins: [vue()],
  server: {
    port: 3000,
  },
  build: {
    sourcemap: true,
    target: `chrome${versions.chrome}`,
    outDir: 'dist',
    rollupOptions: {
      external: [
        'electron',
        ...builtinModules,
      ],
    },
    emptyOutDir: true,
  },
})
