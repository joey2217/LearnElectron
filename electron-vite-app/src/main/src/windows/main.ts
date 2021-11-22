import { BrowserWindow } from 'electron'
import * as path from 'path'

let win: BrowserWindow | null = null;

export function create() {
  win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: true
    }
  })
  if (import.meta.env.DEV) {
    win.loadURL('http://localhost:3000')
  } else {
    win.loadFile(path.resolve('../../../renderer/dist/index.html'))
  }
}