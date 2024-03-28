import "@hotwired/turbo-rails"
import "./controllers"

import Rails from '@rails/ujs'
Rails.start()

import './trix-customization'

import "@fortawesome/fontawesome-free"

import flatpickr from 'flatpickr'
import { French } from 'flatpickr/dist/l10n/fr'

import BSN from 'bootstrap.native/dist/bootstrap-native.js'
window.BSN = BSN

import Snackbar from 'node-snackbar'
window.Snackbar = Snackbar

import offCanvas from './js/off-canvas'

import dependentFields from './js/dependent-fields'

import salaryRangeInputsHandling from './js/salary-range-inputs-handling'

import emailTemplateSelectHandling from './js/email-template-select-handling'

import formAutoSubmit from './js/form-auto-submit'
window.formAutoSubmit = formAutoSubmit

import inPlaceEdit from './js/in-place-edit'
window.inPlaceEdit = inPlaceEdit

import timeoutAlert from './js/timeout-alert'

import displayCharts from './js/display-charts'

import displaySnackbars from './js/display-snackbars'

import { boardManagement, boardRedraw, boardShowRejectionModal } from './js/board'
window.boardRedraw = boardRedraw
window.boardShowRejectionModal = boardShowRejectionModal

import reloadWithTurbo from './js/reload-with-turbo'
window.reloadWithTurbo = reloadWithTurbo

document.addEventListener('turbo:load', function () {
  BSN.initCallback()

  ;[].forEach.call(document.querySelectorAll('.allow-focus'), function(node) {
    node.addEventListener('click', function(e) {
      e.stopPropagation();
    })
  })

  offCanvas()
  formAutoSubmit()
  inPlaceEdit()
  salaryRangeInputsHandling()
  emailTemplateSelectHandling()
  dependentFields()
  displayCharts()
  displaySnackbars()
  boardManagement()
  timeoutAlert()

  flatpickr('#job_offer_contract_start_on', {
    locale: French,
    altInput: true,
    altFormat: 'd/m/Y',
    dateFormat: 'Y-m-d'
  })
  flatpickr('#job_offer_pep_date', {
    locale: French,
    altInput: true,
    altFormat: 'd/m/Y',
    dateFormat: 'Y-m-d'
  })
  flatpickr('#job_offer_bne_date', {
    locale: French,
    altInput: true,
    altFormat: 'd/m/Y',
    dateFormat: 'Y-m-d'
  })
})
