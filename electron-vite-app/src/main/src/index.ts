import { app } from 'electron'
import { create as createMainWindow } from './windows/main'

const gotTheLock = app.requestSingleInstanceLock()

if (!gotTheLock) {
  app.quit()
} else {
  app.on('second-instance', (event, commandLine, workingDirectory) => {
    // TODO
    // 当运行第二个实例时,将会聚焦到myWindow这个窗口
  })
  app.whenReady().then(() => {
    createMainWindow()
  })
}