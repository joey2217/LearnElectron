interface IElectronAPI {
  openAboutWindow: () =>  Promise<void>
}

interface IDevAPI {
  toggleMainDevtools: () => Promise<void>
}

declare global {
  interface Window {
    electronAPI: IElectronAPI
    devAPI: IDevAPI
  }
}

export {}
