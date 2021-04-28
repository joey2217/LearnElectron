const {ipcRenderer} = require('electron')

ipcRenderer.invoke('message',1,2,3)