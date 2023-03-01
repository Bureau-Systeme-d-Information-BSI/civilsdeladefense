const { environment, config } = require('@rails/webpacker')

if (process.env.WEBPACK_HOST) {
  environment.config.devServer.public = process.env.WEBPACK_HOST;
}

module.exports = environment
