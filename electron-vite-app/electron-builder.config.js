const { version } = require('./package.json')

/**
 * @type {import('electron-builder').Configuration}
 * @see https://www.electron.build/configuration/configuration
 */
module.exports = {
  directories: {
    output: 'release',
    buildResources: 'resources',
  },
  files: [
    'dist',
  ],
  extraMetadata: {
    version,
  },
};
