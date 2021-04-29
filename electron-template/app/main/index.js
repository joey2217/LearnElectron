const { app } = require('electron')
const handleIPC = require('./ipc')
const isDev = require('electron-is-dev')
const { create: createMainWindow, show: showMainWindow, close: closeMainWindow } = require('./windows/main')

if (require('electron-squirrel-startup')) app.quit() // window 更新
const single = app.requestSingleInstanceLock()
if (!single) {
  app.quit()
} else {
  app.on("second-instance", () => {
    // 禁止多开
    showMainWindow()
  })
  app.on('will-finish-launching',()=>{
    if (!isDev) {
      require('./updater.js') //更新服务
    }
    require('./crash-reporter').init() // 崩溃监控
  })
  app.on('ready', () => {
    createMainWindow()
    handleIPC()
    require('./trayAndMenu')
  })

  app.on('before-quit', () => {
    closeMainWindow()
  })

  app.on('activate', () => {
    showMainWindow()
  })
}
