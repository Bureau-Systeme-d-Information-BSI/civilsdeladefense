import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "downcheckbox", "upcheckbox" ]

  propagate_downward(event) {
    this.downcheckboxTargets.forEach((element, index) => {
      element.checked = event.target.checked
    })
  }

  propagate_upward(event) {
    if(this.downcheckboxTargets.every(elem => elem.checked)) {
      this.upcheckboxTarget.checked = true;
    } else if(this.downcheckboxTargets.some(elem => !elem.checked)) {
      this.upcheckboxTarget.checked = false;
    }
  }
}
