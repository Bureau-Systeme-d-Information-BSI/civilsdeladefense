import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["role", "employers"];

  connect() {
    this.roleChanged();
  }

  roleChanged() {
    if (this.roleTarget.value !== "admin") {
      this.employersTarget.classList.remove("d-none");
    } else {
      this.employersTarget.classList.add("d-none");
    }
  }
}
