import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "passwordInput", "showButton", "hideButton" ]

  toggle() {
    if (this.isPasswordVisible()) {
      this.hidePassword()
    } else {
      this.showPassword()
    }
  }

  // private

  isPasswordVisible() {
    return this.passwordInputTarget.type === "text"
  }

  showPassword() {
    this.passwordInputTarget.type = "text"
    this.showButtonTarget.classList.add("d-none")
    this.hideButtonTarget.classList.remove("d-none")
  }

  hidePassword() {
    this.passwordInputTarget.type = "password"
    this.showButtonTarget.classList.remove("d-none")
    this.hideButtonTarget.classList.add("d-none")
  }
}
