import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "form" ]

  submit() {
    if (this.hasFormTarget) {
      this.formTarget.requestSubmit();
    } else {
      this.element.closest('form').requestSubmit();
    }
  }
}
