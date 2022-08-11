import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "ignored"]

  connect() {
    this.populateFormFromSavedData()
  }

  saveFormData() {
    localStorage.setItem(this.getLocalStorageKey(), this.getStringifiedFormData())
  }

  clearFormData() {
    if (localStorage.getItem(this.getLocalStorageKey()) == null) return

    localStorage.removeItem(this.getLocalStorageKey())
  }

  // Private methods

  populateFormFromSavedData() {
    if (localStorage.getItem(this.getLocalStorageKey()) == null) return

    const data = this.getSavedData()
    const form = this.formTarget

    Object.entries(data).forEach((entry) => {
      let name = entry[0]
      let value = entry[1]
      let input = form.querySelector(`[name='${name}']`)

      if (input) {
        // Usual case
        input.value = value

        // If input is a trix editor, let's populate it as well
        let trixEditor = input.parentElement.querySelector("trix-editor")
        if (trixEditor != null) {
          trixEditor.editor.insertHTML(value)
        }
      }
    })
  }

  getSavedData() {
    return JSON.parse(localStorage.getItem(this.getLocalStorageKey()))
  }

  getStringifiedFormData() {
    return JSON.stringify(this.getFormData())
  }

  getFormData() {
    const form = new FormData(this.formTarget)

    Array.from(this.formTarget.elements).forEach((input) => {
      if (this.isIgnored(input)) {
        form.delete(input.name)
      }
    })

    let data = []
    for (var pair of form.entries()) {
      data.push([pair[0], pair[1]])
    }
    return Object.fromEntries(data)
  }

  // Ignore inputs when they're about authenticity_token, passwords, captchas, etc
  // Or when they're marked as ignored
  isIgnored(input) {
    const isAuthToken = input.name === "authenticity_token"
    const isPassword = input.type === "password"
    const isFile = input.type === "file"
    const isCaptchaSpinner = input.name === "spinner"
    const isIgnoredTarget = this.ignoredTargets.map(input => input.name).includes(input.name)

    return isAuthToken || isPassword || isFile || isCaptchaSpinner || isIgnoredTarget
  }

  getLocalStorageKey() {
    return window.location
  }
}
