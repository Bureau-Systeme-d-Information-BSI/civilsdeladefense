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
Trix.config.blockAttributes.default.tagName = "align-justify"
Trix.config.blockAttributes.default.breakOnReturn = true
Trix.config.lang.bold = "Gras"
Trix.config.lang.italic = "Italique"
Trix.config.lang.code = "Code"
Trix.config.lang.bullets = "Liste à puces"
Trix.config.lang.numbers = "Liste numérotée"
Trix.config.lang.undo = "Annuler"
Trix.config.lang.redo = "Rétablir"
Trix.config.lang.link = "Lier"
Trix.config.lang.unlink = "Délier"
Trix.config.lang.urlPlaceholder = "Entrez une URL"
Trix.config.lang.url = "URL"
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
        <button type="button" class="trix-button trix-button--icon trix-button--icon-link" data-trix-attribute="href" data-trix-action="link" data-trix-key="k" title="${lang.link}" tabindex="-1">${lang.link}</button>
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

    <div class="trix-dialogs" data-trix-dialogs>
      <div class="trix-dialog trix-dialog--link" data-trix-dialog="href" data-trix-dialog-attribute="href">
        <div class="trix-dialog__link-fields">
          <input type="url" name="href" class="trix-input trix-input--dialog" placeholder="${lang.urlPlaceholder}" aria-label="${lang.url}" required data-trix-input>
          <div class="trix-button-group">
            <input type="button" class="trix-button trix-button--dialog" value="${lang.link}" data-trix-method="setAttribute">
            <input type="button" class="trix-button trix-button--dialog" value="${lang.unlink}" data-trix-method="removeAttribute">
          </div>
        </div>
      </div>
    </div>
  `
}
