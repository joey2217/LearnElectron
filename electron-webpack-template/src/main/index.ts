import { app, BrowserWindow, ipcMain } from 'electron'
import * as path from 'path'
// import installExtension, {
//   REACT_DEVELOPER_TOOLS,
//   REDUX_DEVTOOLS
// } from 'electron-devtools-installer'
import IpcEvents from '../common/ipcEvents'

let mainWindow: BrowserWindow | null

function createWindow () {
  mainWindow = new BrowserWindow({
    width: 1100,
    height: 700,
    backgroundColor: '#191622',
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false,
      enableRemoteModule: true,
      webSecurity: false
    }
  })

  if (process.env.NODE_ENV === 'development') {
    mainWindow.loadURL('http://localhost:4000')
  } else {
    mainWindow.loadFile(path.join(__dirname, 'renderer/index.html'))
  }

  mainWindow.on('closed', () => {
    mainWindow = null
  })
}

app
  .on('ready', createWindow)
  .whenReady()
  .then(() => {
    // if (process.env.NODE_ENV === 'development') {
    //   installExtension(REACT_DEVELOPER_TOOLS)
    //     .then((name) => console.log(`Added Extension:  ${name}`))
    //     .catch((err) => console.log('An error occurred: ', err))
    //   installExtension(REDUX_DEVTOOLS)
    //     .then((name) => console.log(`Added Extension:  ${name}`))
    //     .catch((err) => console.log('An error occurred: ', err))
    // }
    ipcMain.handle(IpcEvents.HELLO, (e, s: string) => {
      console.log(s)
    })
  })
app.allowRendererProcessReuse = true
