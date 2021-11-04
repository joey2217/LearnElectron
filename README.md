# LearnElectron

## install

```sh
ELECTRON_MIRROR=http://npm.taobao.org/mirrors/electron/ npm install -D electron
```

## script

- create-react-app

```json
"scripts": {
    "start": "cross-env BROWSER=none react-scripts start",
}
```

- config

[craco config](https://github.com/gsoft-inc/craco/blob/master/packages/craco/README.md#configuration-file)

```sh
yarn add @craco/craco
```

```json
/* package.json */
"scripts": {
   "start": "craco start",
   "build": "craco build",
   "test": "craco test",
}
```

```js
/* craco.config.js */
module.exports = {
  // ...
};
```

- app

```sh
yarn add -D concurrently wait-on
```

```json
"scripts": {
    "start": "concurrently \"npm run start:render\" \"wait-on http://localhost:3000 && npm run start:main\" ",
}
```

## boilerplates

### [electron-forge](https://www.electronforge.io/)

```sh
yarn create electron-app my-app
```

### [electron-builder](https://www.electron.build/)

- [Vue CLI Plugin Electron Builder](https://nklayman.github.io/vue-cli-plugin-electron-builder/)

```sh
vue add electron-builder # in your vue-cli4-app
```

### [React+Webpack](./electron-forge-ts-webpack-app)

```sh
yarn create electron-app my-new-app --template=typescript-webpack
```
