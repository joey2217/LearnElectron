const { ipcMain, app } = require("electron");
const { send: sendMainWindow } = require("./windows/main");

module.exports = function () {
  ipcMain.handle("message", (e, a, b, c) => {
    console.log("on message", a, b, c);
    sendMainWindow("reply", "Received");
  });

  ipcMain.on("reply", (msg) => {
    console.log("on reply", msg);
  });
  ipcMain.handle("down", (e) => {
    const url = "https://v3.cn.vuejs.org/logo.png";
    e.sender.session.downloadURL(url);
    e.sender.session.on("will-download", (e, downItem, webContents) => {
      downItem.setSavePath(app.getPath("desktop") + "/logo.png");
      console.log("will-download");
    });
  });
};
