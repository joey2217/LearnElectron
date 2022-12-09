const { app, session } = require("electron");
const path = require("path");
const os = require("os");

/** @link https://www.electronjs.org/zh/docs/latest/tutorial/devtools-extension */
export function loadDevTools() {
  // on windows
  const vueDevToolsPath = path.join(
    os.homedir(),
    "/AppData/Local/Google/Chrome/User Data/Default/Extensions/ljjemllljcmogpfapbkkighbhhppjdbg/6.0.0.20_0"
  );
  app.whenReady().then(async () => {
    try {
      await session.defaultSession.loadExtension(vueDevToolsPath);
    } catch (error) {
      console.error("loadDevTools Error", error);
    }
  });
}
