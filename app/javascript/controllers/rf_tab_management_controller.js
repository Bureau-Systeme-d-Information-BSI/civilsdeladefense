import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = [ 'tablist', 'panel' ]

  connect() {
    var height = this.panelTarget.offsetHeight + this.tablistTarget.offsetHeight
    this.element.style.height = height + 'px'
  }
}
