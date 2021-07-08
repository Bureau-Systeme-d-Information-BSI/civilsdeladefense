import { Controller } from 'stimulus'

export default class extends Controller {
  static values = { limit: Number }
  static targets = [ "counter", "editor" ]

  connect() {
    this.setLength()
  }

  limit(event) {
    this.setLength()
  }

  setLength() {
    const textLength = this.length()
    this.counterTarget.innerHTML = textLength
    if(textLength > this.limitValue) {
      this.counterTarget.classList.add("font-weight-bold")
      this.counterTarget.classList.add("text-danger")
    } else {
      this.counterTarget.classList.remove("font-weight-bold")
      this.counterTarget.classList.remove("text-danger")
    }
  }

  length() {
    const string = this.editorTest().getDocument().toString()
    return string.length - 1
  }

  editorTest() {
    const { editor } = this.editorTarget
    return editor
  }
}
