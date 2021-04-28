const { ipcMain } = require('electron')
const { send: sendMainWindow } = require('./windows/main')

module.exports = function () {
  ipcMain.handle('message', (e, a, b, c) => {
    console.log('on message', a, b, c);
    sendMainWindow('reply', 'Received')
  })

  ipcMain.on('reply', msg => {
    console.log('on reply', msg);
  })
}