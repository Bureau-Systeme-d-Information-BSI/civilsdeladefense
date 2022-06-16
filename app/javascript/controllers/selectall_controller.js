import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ["page", "item"]

  change(event) {
    this.pageTarget.checked = false
    this.pageTarget.disabled = event.target.checked
    this.itemTargets.forEach((element,) => {
      element.checked = event.target.checked
      element.disabled = event.target.checked
    })
  }
}
