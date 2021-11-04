const { app, globalShortcut } = require("electron");
const { send: sendMainWindow } = require("./windows/main");

app.whenReady().then(() => {
  // Register a 'CommandOrControl+X' shortcut listener.
  const ret = globalShortcut.register("CommandOrControl+X", () => {
    sendMainWindow("cut");
  });

  if (!ret) {
    console.log("registration failed");
  }

  // 检查快捷键是否注册成功
  console.log(globalShortcut.isRegistered("CommandOrControl+X"));
});

app.on("will-quit", () => {
  // 注销快捷键
  globalShortcut.unregister("CommandOrControl+X");

  // 注销所有快捷键
  globalShortcut.unregisterAll();
});
