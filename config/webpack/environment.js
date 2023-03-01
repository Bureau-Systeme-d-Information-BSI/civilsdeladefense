const { environment, config } = require('@rails/webpacker')

const source_path = config.source_path

// TODO
// exclude 'svg' from file loader
// const fileLoader = environment.loaders.get('file')
// fileLoader.test = /\.(jpg|jpeg|png|gif|ico|eot|otf|ttf|woff|woff2)$/i

// environment.loaders.append('svg-no-sprite', {
//   test: /(images)\/(.*)\.svg$/,
//   use: [
//     {
//       loader: 'file-loader', options: {
//         name: '[path][name]-[hash].[ext]',
//         context: source_path
//       }
//     },
//     {
//       loader: 'svgo-loader', options: {
//         plugins: [
//           {cleanupIDs: false},
//           {removeViewBox: false},
//           {removeDimensions: false}
//         ]
//       }
//     }
//   ]
// })

// environment.loaders.append('svg-sprite', {
//   test: /(icons)\/(.*)\.svg$/,
//   use: [
//     { loader: 'svg-sprite-loader' },
//     {
//       loader: 'svgo-loader', options: {
//         plugins: [
//           {cleanupIDs: false},
//           {removeViewBox: false},
//           {removeDimensions: true},
//           {removeAttrs: {attrs: '(stroke|fill)'}}
//         ]
//       }
//     }
//   ]
// })
// environment.loaders.append("sass-loader", {
//   test: /\.s[ac]ss$/i,
//   use: [
//     "style-loader",
//     "css-loader",
//     {
//       loader: "sass-loader",
//       options: {
//         implementation: require.resolve("sass"),
//         sassOptions: {
//           includePaths: [
//             path.resolve(__dirname, 'node_modules/@gouvfr/dsfr/'),
//           ],
//         },
//       },
//     },
//   ]
// })

if (process.env.WEBPACK_HOST) {
  environment.config.devServer.public = process.env.WEBPACK_HOST;
}

module.exports = environment
