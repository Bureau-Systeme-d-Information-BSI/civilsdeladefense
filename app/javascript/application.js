// jQuery as global
export { $ } from 'jquery'

require("@gouvfr/dsfr/dist/js/dsfr.module.min.js")

// function importAll(r) {
//   return r.keys().map(r)
// }

// importAll(require.context('images/', true, /\.(ico|png|jpe?g|svg|gif)$/))
// importAll(require.context('icons/', true, /\.svg$/))


import { Turbo } from "@hotwired/turbo-rails"
window.Turbo = Turbo

import { Application } from "@hotwired/stimulus"
// import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

// window.Stimulus = Application.start()
// const context = require.context("../controllers", true, /\.js$/)
// Stimulus.load(definitionsFromContext(context))

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers"

// Import everything from bootstrap
import * as bootstrap from 'bootstrap'

document.addEventListener("turbo:load", function() {
  var tooltipTriggerList = [].slice.call(
  document.querySelectorAll('[data-bs-toggle="tooltip"]'))

  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
      return new bootstrap.Tooltip(tooltipTriggerEl)
  })

  var popoverTriggerList = [].slice.call(
  document.querySelectorAll('[data-bs-toggle="popover"]'))

  var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
    return new bootstrap.Popover(popoverTriggerEl)
  })
})
