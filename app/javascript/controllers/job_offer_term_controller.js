import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "checkbox", "submit", "warning" ]

  check(event) {
    if(this.checkboxTargets.every(elem => elem.checked)) {
      this.warningTarget.classList.remove('d-none')
      this.submitTarget.disabled = true;
    } else if(this.checkboxTargets.some(elem => elem.checked)) {
      this.warningTarget.classList.add('d-none')
      this.submitTarget.disabled = false;
    } else if(this.checkboxTargets.every(elem => !elem.checked)) {
      this.warningTarget.classList.add('d-none')
      this.submitTarget.disabled = true;
    }
  }
}
