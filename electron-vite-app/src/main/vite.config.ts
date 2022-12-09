import { defineConfig } from "vite";
import { builtinModules } from "module";
import * as path from "path";

const NODE_VERSION = "16";
const ROOT = path.resolve(__dirname, "../../");

// https://vitejs.dev/config/
export default defineConfig({
  root: __dirname,
  envDir: process.cwd(),
  build: {
    target: `node${NODE_VERSION}`,
    outDir: path.join(ROOT, "dist"),
    emptyOutDir: true,
    rollupOptions: {
      input: {
        main: path.join(__dirname, "index.ts"),
        preload: path.join(__dirname, "windows/preload.ts"),
      },
      external: ["electron", ...builtinModules],
      output: {
        entryFileNames: "[name].cjs",
      },
    },
  },
});
