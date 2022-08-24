import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'tablist', 'panel' ]

  connect() {
    this.resize()
  }
  
  resize() {
    var height = this.panelTarget.offsetHeight + this.tablistTarget.offsetHeight
    this.element.style.height = height + 'px'
  }
}
