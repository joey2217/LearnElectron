const { spawn } = require('child_process');
const { build, createLogger, createServer } = require('vite')
const electron = require('electron');
const path = require('path')

const ROOT = path.resolve(__dirname, '../')

let electronProcess;

const logger = createLogger('info', {
  prefix: '[main]',
});

const defaultLogOptions = {
  timestamp: true
}

async function start() {
  await startRendererServer(path.join(ROOT, 'src/renderer/main/vite.config.ts'))
  const watcher = await build({
    configFile: path.join(ROOT, 'src/main/vite.config.ts'),
    mode: 'development',
    build: {
      watch: {}
    }
  })
  watcher.on('event', function (e) {
    logger.info(`build ${e.code}`, defaultLogOptions)
    if (e.code === 'END') {
      startElectron()
    }
  })
}

function startElectron() {
  logger.info('start electron', defaultLogOptions);
  if (electronProcess !== null) {
    electronProcess = null;
  }
  electronProcess = spawn(electron, [path.join(ROOT, 'dist/main/index.cjs')])
  // electronProcess.stdout.on('data', (data) => {
  //   logger.info(data.toString(), defaultLogOptions)
  // });

  electronProcess.stderr.on('data', (data) => {
    logger.error(data.toString(), defaultLogOptions);
  });

  electronProcess.on('close', (code) => {
    electronProcess = null
    logger.error(`child process exited with code ${code}`, defaultLogOptions);
    process.exit()
  });
}

async function startRendererServer(configFile, port = 3000) {
  const viteDevServer = await createServer({
    configFile,
    mode: 'development',
    server: {
      port,
    }
  });
  await viteDevServer.listen();
  logger.info(`renderer server start at: http://localhost:${port}`, { ...defaultLogOptions, prefix: ['renderer'] },)
  return viteDevServer
}

start()