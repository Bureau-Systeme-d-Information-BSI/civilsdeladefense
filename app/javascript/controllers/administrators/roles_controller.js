import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["roles", "employers", "aceAte"];

  connect() {
    this.rolesChanged();
  }

  rolesChanged() {
    if (this.getRoles().includes("employment_authority")) {
      this.aceAteTarget.classList.remove("d-none");
    } else {
      this.aceAteTarget.classList.add("d-none");
    }

    if (this.getRoles().includes("functional_administrator")) {
      this.employersTarget.classList.add("d-none");
      this.employersTarget.querySelector(
        "#administrator_employer_ids",
      ).required = false;
      this.aceAteTarget.classList.add("d-none");
    } else {
      this.employersTarget.classList.remove("d-none");
      this.employersTarget.querySelector(
        "#administrator_employer_ids",
      ).required = true;
    }
  }

  getRoles() {
    return Array.from(this.rolesTarget.selectedOptions).map(
      (option) => option.value,
    );
  }
}
