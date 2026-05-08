import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  open() {
    this.dialogTarget.showModal()
    this.dialogTarget.classList.add("rf-modal--opened")
  }

  close() {
    this.dialogTarget.classList.remove("rf-modal--opened")
    this.dialogTarget.close()
  }
}
