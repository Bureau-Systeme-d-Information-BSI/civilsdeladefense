/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

window.Stimulus = Application.start()
const context = require.context("../controllers", true, /\.js$/)
Stimulus.load(definitionsFromContext(context))

import "@hotwired/turbo-rails"

// Import Rails UJS
import Rails from '@rails/ujs'
Rails.start()



// Import Trix
class BaseElement extends HTMLElement {
  constructor() {
    super()
    this.attachShadow({ mode: 'open' })
  }
}

function innerHTML(alignment) {
  return `
    <style>
      :host {
        text-align: ${alignment};
        width: 100%;
        display: block;
      }
    </style>

    <slot></slot>
  `
}

export class AlignLeftElement extends BaseElement {
  constructor() {
    super()

    this.shadowRoot.innerHTML = innerHTML('left')
  }
}

export class AlignCenterElement extends BaseElement {
  constructor() {
    super()

    this.shadowRoot.innerHTML = innerHTML('center')
  }
}

export class AlignRightElement extends BaseElement {
  constructor() {
    super()

    this.shadowRoot.innerHTML = innerHTML('right')
  }
}

export class AlignJustifyElement extends BaseElement {
  constructor() {
    super()

    this.shadowRoot.innerHTML = innerHTML('justify')
  }
}

window.customElements.define('align-left', AlignLeftElement)
window.customElements.define('align-center', AlignCenterElement)
window.customElements.define('align-right', AlignRightElement)
window.customElements.define('align-justify', AlignJustifyElement)



import Trix from 'trix'
Trix.config.blockAttributes.default.tagName = "p"
Trix.config.blockAttributes.default.breakOnReturn = true
Trix.config.lang.bold = "Gras"
Trix.config.lang.italic = "Italique"
Trix.config.lang.code = "Code"
Trix.config.lang.bullets = "Liste à puces"
Trix.config.lang.numbers = "Liste numérotée"
Trix.config.lang.undo = "Annuler"
Trix.config.lang.redo = "Rétablir"
Trix.config.toolbar.getDefaultHTML = toolbarDefaultHTML
Trix.config.blockAttributes.alignLeft = {
  tagName: 'align-left', 
  nestable: false,
  exclusive: true,
}
Trix.config.blockAttributes.alignCenter = {
  tagName: 'align-center',
  nestable: false,
  exclusive: true,
}

Trix.config.blockAttributes.alignRight = {
  tagName: 'align-right',
  nestable: false,
  exclusive: true,
}
Trix.config.blockAttributes.alignJustify = {
  tagName: 'align-justify',
  nestable: false,
  exclusive: true,
}

// To add / customise trix toolbar buttons: https://github.com/basecamp/trix/blob/main/src/trix/config/toolbar.js
function toolbarDefaultHTML() {
  const {lang} = Trix.config
  return `
    <div class="trix-button-row">
      <span class="trix-button-group trix-button-group--text-tools" data-trix-button-group="text-tools">
        <button type="button" class="trix-button trix-button--icon trix-button--icon-bold" data-trix-attribute="bold" data-trix-key="b" title="${lang.bold}" tabindex="-1">${lang.bold}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-italic" data-trix-attribute="italic" data-trix-key="i" title="${lang.italic}" tabindex="-1">${lang.italic}</button>
      </span>
      <span class="trix-button-group trix-button-group--block-tools" data-trix-button-group="block-tools">
        <button type="button" class="trix-button trix-button--icon trix-button--icon-code" data-trix-attribute="code" title="${lang.code}" tabindex="-1">${lang.code}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-bullet-list" data-trix-attribute="bullet" title="${lang.bullets}" tabindex="-1">${lang.bullets}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-number-list" data-trix-attribute="number" title="${lang.numbers}" tabindex="-1">${lang.numbers}</button>
      </span>
      <span class="trix-button-group trix-button-group--alignment-tools">
        <button type="button" class="trix-button trix-button--icon trix-button--icon-align-left" data-trix-attribute="alignLeft" title="Aligner à gauche" tabindex="-1">Aligner à gauche</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-align-center" data-trix-attribute="alignCenter" title="Aligner au centre" tabindex="-1">Aligner au centre</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-align-right" data-trix-attribute="alignRight" title="Aligner à droite" tabindex="-1">Aligner à droite</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-align-justify" data-trix-attribute="alignJustify" title="Justifier" tabindex="-1">Justifier</button>
      </span>
      <span class="trix-button-group-spacer"></span>
      <span class="trix-button-group trix-button-group--history-tools" data-trix-button-group="history-tools">
        <button type="button" class="trix-button trix-button--icon trix-button--icon-undo" data-trix-action="undo" data-trix-key="z" title="${lang.undo}" tabindex="-1">${lang.undo}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-redo" data-trix-action="redo" data-trix-key="shift+z" title="${lang.redo}" tabindex="-1">${lang.redo}</button>
      </span>
    </div>
  `
}

import flatpickr from 'flatpickr'
import { French } from 'flatpickr/dist/l10n/fr'

function importAll(r) {
  return r.keys().map(r)
}

importAll(require.context('images/', true, /\.(ico|png|jpe?g|svg|gif)$/))
importAll(require.context('icons/', true, /\.svg$/))

import BSN from 'bootstrap.native/dist/bootstrap-native.js'
window.BSN = BSN
import Snackbar from 'node-snackbar'
window.Snackbar = Snackbar
import offCanvas from 'js/off-canvas'
import dependentFields from 'js/dependent-fields'
import salaryRangeInputsHandling from 'js/salary-range-inputs-handling'
import emailTemplateSelectHandling from 'js/email-template-select-handling'
import formAutoSubmit from 'js/form-auto-submit'
window.formAutoSubmit = formAutoSubmit
import inPlaceEdit from 'js/in-place-edit'
window.inPlaceEdit = inPlaceEdit
import timeoutAlert from 'js/timeout-alert'
import displayCharts from 'js/display-charts'
import displaySnackbars from 'js/display-snackbars'
import { boardManagement, boardRedraw, boardShowRejectionModal } from 'js/board'
window.boardRedraw = boardRedraw
window.boardShowRejectionModal = boardShowRejectionModal
import reloadWithTurbo from 'js/reload-with-turbo'
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
