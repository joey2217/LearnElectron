export function openAboutWindow() {
  window.electronAPI.openAboutWindow()
}

export function toggleDevtools() {
  window.devAPI.toggleDevtools()
}

export function onMessage(callback: (message: string) => void) {
  window.electronAPI.onMessage((e, message) => callback(message))
}
