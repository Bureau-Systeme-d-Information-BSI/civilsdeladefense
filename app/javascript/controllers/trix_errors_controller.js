import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    modelName: String,
    inputs: Array
  }

  connect() {
    this.inputsValue.forEach((inputName) => {
      const trixInput = this.element.querySelector(`[input='${this.modelNameValue}_${inputName}']`)
      if (trixInput && trixInput.parentElement) {
        trixInput.parentElement.classList.add("is-invalid")
      }
    })
  }
}
