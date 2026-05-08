import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["radioWrapper", "toggleable"];

  connect() {
    this.toggle();
  }

  toggle() {
    if (this.isChecked()) {
      this.showToggleable();
    } else {
      this.hideToggleable();
    }
  }

  // private

  isChecked() {
    return (
      this.radioWrapperTarget.querySelector("input:checked").value === "true"
    );
  }

  showToggleable() {
    for (let toggleable of this.toggleableTargets) {
      toggleable.classList.remove("d-none");
    }
  }

  hideToggleable() {
    for (let toggleable of this.toggleableTargets) {
      toggleable.classList.add("d-none");
    }
  }
}
