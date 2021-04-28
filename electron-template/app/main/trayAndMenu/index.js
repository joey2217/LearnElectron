// 菜单和托盘
if (process.platform === 'darwin') {
  require('./darwin')
} else if (process.platform === 'win32') {
  require('./win32')
} else {
  // TODO
}