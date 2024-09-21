import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "duplicated", "root", "element", "addButton" ]
  static values = { max: Number }

  connect() {
    this.setAddButtonVisibility();
  }

  duplicate() {
    var cln = this.duplicatedTarget.cloneNode(true);
    cln.classList.remove("d-none")
    cln.dataset.duplicatorTarget = "element"
    const counter = this.elementTargets.length
    Array.from(cln.getElementsByTagName('select')).forEach((element, index) => {
      element.name = element.name.replace('index', counter)
    })
    this.rootTarget.appendChild(cln);

    this.setAddButtonVisibility();
  }

  remove(event) {
    event.currentTarget.parentNode.parentNode.remove();

    this.setAddButtonVisibility();
  }

  // private

  setAddButtonVisibility() {
    if (typeof this.maxValue === "undefined" || this.maxValue === null || this.maxValue === 0) {
      return;
    }

    if (this.elementTargets.length >= this.maxValue) {
      this.addButtonTarget.classList.add("d-none");
    } else {
      this.addButtonTarget.classList.remove("d-none");
    }
  }
}
