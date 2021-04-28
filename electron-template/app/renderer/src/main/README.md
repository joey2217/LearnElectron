# electron-react

## scripts

- "start": "BROWSER=none react-scripts start",

- "start": "set BROWSER=none && react-scripts start",

## 引入electron

- window.require

```js
const { ipcRenderer } = window.require('electron')

// main
webPreferences: {
  contextIsolation: false
}
```

- 修改webpack target

<https://webpack.js.org/configuration/target/#root>

```js
// config-overrides.js
const { override  } = require('customize-cra');

function addRendererTarget(config) {
    config.target = 'electron-renderer'
    return config
}

module.exports = override(addRendererTarget)
```

## build

```json
  "homepage": "./",
```
