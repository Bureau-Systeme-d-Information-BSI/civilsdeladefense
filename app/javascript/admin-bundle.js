export { $ } from 'jquery'

import { Application } from "@hotwired/stimulus"
// import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

// window.Stimulus = Application.start()
// const context = require.context("../controllers", true, /\.js$/)
// Stimulus.load(definitionsFromContext(context))

import "@hotwired/turbo-rails"

// Import Rails UJS
import Rails from '@rails/ujs'
Rails.start()

import './trix-customization'


import flatpickr from 'flatpickr'
import { French } from 'flatpickr/dist/l10n/fr'

// function importAll(r) {
//   return r.keys().map(r)
// }

// importAll(require.context('images/', true, /\.(ico|png|jpe?g|svg|gif)$/))
// importAll(require.context('icons/', true, /\.svg$/))

import BSN from 'bootstrap.native/dist/bootstrap-native.js'
window.BSN = BSN
import Snackbar from 'node-snackbar'
window.Snackbar = Snackbar
// import offCanvas from 'js/off-canvas'
// import dependentFields from 'js/dependent-fields'
// import salaryRangeInputsHandling from 'js/salary-range-inputs-handling'
// import emailTemplateSelectHandling from 'js/email-template-select-handling'
// import formAutoSubmit from 'js/form-auto-submit'
// window.formAutoSubmit = formAutoSubmit
// import inPlaceEdit from 'js/in-place-edit'
// window.inPlaceEdit = inPlaceEdit
// import timeoutAlert from 'js/timeout-alert'
// import displayCharts from 'js/display-charts'
// import displaySnackbars from 'js/display-snackbars'
// import { boardManagement, boardRedraw, boardShowRejectionModal } from 'js/board'
// window.boardRedraw = boardRedraw
// window.boardShowRejectionModal = boardShowRejectionModal
// import reloadWithTurbo from 'js/reload-with-turbo'
// window.reloadWithTurbo = reloadWithTurbo

// document.addEventListener('turbo:load', function () {
//   BSN.initCallback()

//   ;[].forEach.call(document.querySelectorAll('.allow-focus'), function(node) {
//     node.addEventListener('click', function(e) {
//       e.stopPropagation();
//     })
//   })

//   offCanvas()
//   formAutoSubmit()
//   inPlaceEdit()
//   salaryRangeInputsHandling()
//   emailTemplateSelectHandling()
//   dependentFields()
//   displayCharts()
//   displaySnackbars()
//   boardManagement()
//   timeoutAlert()

//   flatpickr('#job_offer_contract_start_on', {
//     locale: French,
//     altInput: true,
//     altFormat: 'd/m/Y',
//     dateFormat: 'Y-m-d'
//   })
//   flatpickr('#job_offer_pep_date', {
//     locale: French,
//     altInput: true,
//     altFormat: 'd/m/Y',
//     dateFormat: 'Y-m-d'
//   })
//   flatpickr('#job_offer_bne_date', {
//     locale: French,
//     altInput: true,
//     altFormat: 'd/m/Y',
//     dateFormat: 'Y-m-d'
//   })
// })

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
