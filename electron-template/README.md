# electron-template

## scripts

- start(wait-on concurrently)

```json
  "start": "concurrently \"yarn start:render\"  \"wait-on http://localhost:3000 && yarn start:main\"",
```

## 起名

- 希腊语 熵 k8s

- 神话

## About Window

<https://www.npmjs.com/package/electron-about-window>

## Tip

- electron-is-dev 放在 dependencies 下 , 否则会报错

```sh
docker run --rm -ti \
 --env-file <(env | grep -iE 'DEBUG|NODE_|ELECTRON_|YARN_|NPM_|CI|CIRCLE|TRAVIS_TAG|TRAVIS|TRAVIS_REPO_|TRAVIS_BUILD_|TRAVIS_BRANCH|TRAVIS_PULL_REQUEST_|APPVEYOR_|CSC_|GH_|GITHUB_|BT_|AWS_|STRIP|BUILD_') \
 --env ELECTRON_CACHE="/root/.cache/electron" \
 --env ELECTRON_BUILDER_CACHE="/root/.cache/electron-builder" \
 -v ${PWD}:/project \
 -v ${PWD##*/}-node-modules:/project/node_modules \
 -v ~/.cache/electron:/root/.cache/electron \
 -v ~/.cache/electron-builder:/root/.cache/electron-builder \
 electronuserland/builder:wine
```