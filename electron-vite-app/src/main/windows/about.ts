import { BrowserWindow } from 'electron'
import * as path from 'path'

let win: BrowserWindow = null!

export function create() {
  win = new BrowserWindow({
    width: 800,
    height: 500,
    webPreferences: {
      preload: path.join(__dirname,'preload.js'),
    },
  })
  if (import.meta.env.DEV) {
    win.loadURL('http://localhost:5174/about.html')
  } else {
    win.loadFile(path.join(__dirname, 'renderer/about.html'))
  }
}

export function open() {
  if (win) {
    if (win.isMinimized()) {
      win.restore()
    } else {
      win.focus()
    }
  } else {
    create()
  }
}
