import { defineConfig } from 'vite'
import { builtinModules } from 'module'
import * as path from 'path'
import { versions } from '../../electron-vendors.config'
import { ROOT } from '../common/constant'

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => {
  console.log(mode, 'mode')
  return {
    root: __dirname,
    envDir: process.cwd(),
    build: {
      sourcemap: 'inline',
      target: `node${versions.node}`,
      outDir: path.join(ROOT, 'dist', 'main'),
      lib: {
        entry: 'src/index.ts',
        formats: ['cjs'],
      },
      minify: mode !== 'development',
      rollupOptions: {
        external: ['electron', ...builtinModules],
        output: {
          entryFileNames: '[name].cjs',
        },
      },
      emptyOutDir: true,
    },
  }
})
