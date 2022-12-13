interface IElectronAPI {
  openAboutWindow: () => Promise<void>
  onMessage: (
    callback: (event: Electron.IpcRendererEvent, message: string) => void
  ) => Electron.IpcRenderer
  sendMessageToMain: (message: string) => Promise<void>
}

interface IDevAPI {
  toggleDevtools: () => Promise<void>
}

declare global {
  interface Window {
    electronAPI: IElectronAPI
    devAPI: IDevAPI
  }
}

export {}
