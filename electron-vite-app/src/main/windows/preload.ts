import { contextBridge, ipcRenderer } from 'electron'

contextBridge.exposeInMainWorld('darkMode', {
  toggle: () => ipcRenderer.invoke('dark-mode:toggle'),
  system: () => ipcRenderer.invoke('dark-mode:system'),
})

contextBridge.exposeInMainWorld('devAPI', {
  toggleMainDevtools: () => ipcRenderer.invoke('TOGGLE_MAIN_DEVTOOLS'),
})

contextBridge.exposeInMainWorld('electronAPI', {
  openAboutWindow: () => ipcRenderer.invoke('OPEN_ABOUT_WINDOW'),
})

contextBridge.exposeInMainWorld('versions', {
  node: () => process.versions.node,
  chrome: () => process.versions.chrome,
  electron: () => process.versions.electron,
  // 能暴露的不仅仅是函数，我们还可以暴露变量
})
