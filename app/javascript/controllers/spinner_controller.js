import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'spinner', 'button' ]

  show() {
    this.spinnerTarget.classList.remove('d-none')
    this.buttonTarget.classList.add('d-none')
  }
}
