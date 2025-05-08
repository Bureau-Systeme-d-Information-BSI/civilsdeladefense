import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submit"]

  reasonChanged(event) {
    this.submitTarget.disabled = event.target.value.length === 0
  }
}