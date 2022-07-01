import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "form", "input" ]

  highlight(event) {
    event.preventDefault()
    event.currentTarget.classList.add('highlight')
  }

  unhighlight(event) {
    event.preventDefault()
    event.currentTarget.classList.remove('highlight')
  }

  setFile(event) {
    event.preventDefault()
    const files = event.dataTransfer.files
    this.inputTarget.files = files
    this.formTarget.submit()
  }
}
