import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "element", "addButton" ]

  connect() {
    if (this.elementTargets.length === 0) {
      this.addButtonTarget.click();
    }
  }
}
