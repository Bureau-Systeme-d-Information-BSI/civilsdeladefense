import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = [ "duplicated", "root" ]

  duplicate() {
    var cln = this.duplicatedTarget.cloneNode(true);
    cln.children[1].classList.remove("d-none");
    this.rootTarget.appendChild(cln);
  }

  remove(event) {
    event.currentTarget.parentNode.parentNode.remove();
  }
}
