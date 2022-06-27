import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "duplicated", "root", "element" ]

  duplicate() {
    var cln = this.duplicatedTarget.cloneNode(true);
    cln.classList.remove("d-none")
    cln.dataset.duplicatorTarget = "element"
    const counter = this.elementTargets.length
    Array.from(cln.getElementsByTagName('select')).forEach((element, index) => {
      element.name = element.name.replace('index', counter)
    })
    this.rootTarget.appendChild(cln);
  }

  remove(event) {
    event.currentTarget.parentNode.parentNode.remove();
  }
}
