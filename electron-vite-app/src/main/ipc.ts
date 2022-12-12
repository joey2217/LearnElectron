import { ipcMain } from 'electron'
import { toggleDevtools as toggleMainDevtools } from './windows/main'
import { open as openAboutWindow } from './windows/about'

export default function handleIPC() {
  ipcMain.handle('TOGGLE_MAIN_DEVTOOLS', () => {
    toggleMainDevtools()
  })

  ipcMain.handle('OPEN_ABOUT_WINDOW', () => {
    openAboutWindow()
  })
}
