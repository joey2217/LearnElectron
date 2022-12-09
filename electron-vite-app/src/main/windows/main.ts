import { BrowserWindow } from 'electron'
import * as path from 'path'

let win: BrowserWindow = null!

export function create() {
  win = new BrowserWindow({
    width: 800,
    height: 500,
    webPreferences: {
      preload: './preload.cjs',
    },
  })
  if (import.meta.env.DEV) {
    win.loadURL('http://localhost:3000')
  } else {
    win.loadFile(path.join(__dirname, 'renderer/index.html'))
  }
}

export function focus() {
  if (win) {
    if (win.isMinimized()) win.restore()
    win.focus()
  }
}
