import { BrowserWindow } from 'electron'
import * as path from 'path'
import { ROOT } from '../../../common/constant'

let win: BrowserWindow | null = null

export function create() {
  win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: true,
    },
  })
  if (import.meta.env.DEV) {
    win.loadURL('http://localhost:3000')
  } else {
    win.loadFile(path.join(ROOT, 'dist/renderer/main/index.html'))
  }
}

export function focus() {
  if (win) {
    if (win.isMinimized()) win.restore()
    win.focus()
  }
}
