import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["roles", "employers", "aceAte"];

  connect() {
    this.rolesChanged();
  }

  rolesChanged() {
    if (this.getRoles().includes("functional_administrator")) {
      this.employersTarget.classList.add("d-none");
      this.aceAteTarget.classList.add("d-none");
    } else {
      this.employersTarget.classList.remove("d-none");

      if (this.getRoles().includes("employment_authority")) {
        this.aceAteTarget.classList.remove("d-none");
      }
    }
  }

  getRoles() {
    return Array.from(this.rolesTarget.selectedOptions).map(option => option.value);
  }
}
