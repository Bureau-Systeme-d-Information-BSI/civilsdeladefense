process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

// Watch directories that often change the views.
// From: https://github.com/rails/webpacker/issues/1879#issuecomment-558397652
const chokidar = require('chokidar')

if(environment.config.devServer) {
  environment.config.devServer.before = (app, server) => {
    chokidar.watch([
      'config/locales/*.yml',
      'app/views/**/*.haml'
    ]).on('change', () => server.sockWrite(server.sockets, 'content-changed'))
  }
}

module.exports = environment.toWebpackConfig()
