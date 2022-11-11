// Modules to control application life and create native browser window
const { app, BrowserWindow } = require('electron')
const path = require('path')

/** @type BrowserWindow */
let mainWindow
let timer

function createWindow() {
  // Create the browser window.
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: true,
    },
  })

  // and load the index.html of the app.
  mainWindow.loadFile('index.html')

  // Open the DevTools.
  // mainWindow.webContents.openDevTools()
  mainWindow.on('close', () => {
    clearInterval(timer)
  })
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.whenReady().then(() => {
  createWindow()

  app.on('activate', function () {
    // On macOS it's common to re-create a window in the app when the
    // dock icon is clicked and there are no other windows open.
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})

// Quit when all windows are closed, except on macOS. There, it's common
// for applications and their menu bar to stay active until the user quits
// explicitly with Cmd + Q.
app.on('window-all-closed', function () {
  if (process.platform !== 'darwin') app.quit()
})

// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and require them here.
app.whenReady().then(() => {
  const steamworks = require('steamworks.js')
  // steamworks.electronEnableSteamOverlay(true)
  const client = steamworks.init()
  // Print Steam username
  console.log(client.localplayer.getName())
  // Tries to activate an achievement
  if (client.achievement.activate('ACHIEVEMENT')) {
    // ...
  }
  client.input.init()
  console.log(steamworks.SteamCallback)
  timer = setInterval(() => {
    const controllers = client.input.getControllers()
    if (controllers.length > 0) {
      let controller = controllers[0]
      const num1 = client.input.getActionSet('A')
      const num2 = client.input.getActionSet('B')
      const num3 = client.input.getActionSet('X')
      controller.activateActionSet(num1)
      controller.activateActionSet(num2)
      controller.activateActionSet(num3)
      const pressed1 = controller.isDigitalActionPressed(num1)
      const pressed2 = controller.isDigitalActionPressed(num2)
      const pressed3 = controller.isDigitalActionPressed(num3)
      const res = {
        num1: Number(num1),
        num2: Number(num2),
        num3: Number(num3),
        pressed1,
        pressed2,
        pressed3,
      }
      console.log(res)
      if (mainWindow) {
        mainWindow.webContents.send('game-pad-data', res)
      }
    }
  }, 1000)
})
