const openAboutWindow = require('about-window').default
const path = require('path')

const create = () => openAboutWindow({
  icon_path: path.resolve(__dirname, 'icon.png'),
  package_json_dir: path.resolve(__dirname, '../../../'),
  copyright: 'copyright (c) 2021 Joey',
  homepage: 'https://github.com/BurNing1993/LearnElectron'
})


module.exports = { create }