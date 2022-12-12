import { defineConfig } from 'vite'
import { builtinModules } from 'module'
import * as path from 'path'

const NODE_VERSION = '16'
const ROOT = path.resolve(__dirname, '../../')

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => {
  return {
    root: __dirname,
    envDir: process.cwd(),
    build: {
      sourcemap: mode === 'development' ? false : 'inline',
      target: `node${NODE_VERSION}`,
      outDir: path.join(ROOT, 'dist'),
      emptyOutDir: true,
      minify: mode === 'development' ? false : 'esbuild',
      lib: {
        entry: {
          main: path.join(__dirname, 'index.ts'),
          preload: path.join(__dirname, 'windows/preload.ts'),
        },
        formats: ['cjs'],
      },
      rollupOptions: {
        external: ['electron', ...builtinModules],
        output: {
          format: 'cjs',
        },
      },
    },
  }
})
