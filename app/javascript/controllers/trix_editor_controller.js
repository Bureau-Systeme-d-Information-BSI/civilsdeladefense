import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { maximum: Number }
  static targets = [ "counter", "editor", "limit" ]

  updateCounter() {
    this.showLimit()
    this.setLength()
  }

  // private

  showLimit() {
    this.limitTarget.classList.remove("d-none")
  }

  setLength() {
    const textLength = this.length()
    this.counterTarget.innerHTML = textLength
    if(textLength > this.maximumValue) {
      this.counterTarget.classList.add("font-weight-bold")
      this.counterTarget.classList.add("text-danger")
    } else {
      this.counterTarget.classList.remove("font-weight-bold")
      this.counterTarget.classList.remove("text-danger")
    }
  }

  length() {
    const { editor } = this.editorTarget
    return editor.getDocument().toString().length - 1
  }
}
