// Modules to control application life and create native browser window
const { app, BrowserWindow } = require("electron");
const path = require("path");

/** @type BrowserWindow */
let mainWindow;
let timer;

function createWindow() {
  // Create the browser window.
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      preload: path.join(__dirname, "preload.js"),
      contextIsolation: true,
      nodeIntegration: true,
    },
  });

  // and load the index.html of the app.
  mainWindow.loadFile("index.html");

  // Open the DevTools.
  // mainWindow.webContents.openDevTools()
  mainWindow.on("close", () => {
    clearInterval(timer);
  });
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.whenReady().then(() => {
  createWindow();

  app.on("activate", function () {
    // On macOS it's common to re-create a window in the app when the
    // dock icon is clicked and there are no other windows open.
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

// Quit when all windows are closed, except on macOS. There, it's common
// for applications and their menu bar to stay active until the user quits
// explicitly with Cmd + Q.
app.on("window-all-closed", function () {
  if (process.platform !== "darwin") app.quit();
});

// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and require them here.
// https://github.com/ceifa/steamworks.js/blob/main/test/input.js
app.whenReady().then(() => {
  const steamworks = require("steamworks.js");
  // steamworks.electronEnableSteamOverlay(true)
  const client = steamworks.init(2159840);
  // Print Steam username
  console.log(client.localplayer.getName());
  // Tries to activate an achievement
  if (client.achievement.activate("ACHIEVEMENT")) {
    // ...
  }
  client.input.init();

  const actionset = client.input.getActionSet("MenuControls");

  const affirm = client.input.getDigitalAction("MenuUp");
  const cancel = client.input.getDigitalAction("MenuDown");
  const control = client.input.getAnalogAction("MenuLeft");           
  console.log(`affirm:${affirm},cancel:${cancel},control:${control}`)
  setInterval(() => {
    console.clear();

    const controllers = client.input.getControllers();
    console.log("Controllers: " + controllers.length);

    controllers.forEach((controller) => {
      controller.activateActionSet(actionset);
      console.log("============");
      console.log("Affirm: " + controller.isDigitalActionPressed(affirm));
      console.log("Cancel: " + controller.isDigitalActionPressed(cancel));
      console.log(
        "Control: " + JSON.stringify(controller.getAnalogActionVector(control))
      );
    });
  }, 1000);
});
