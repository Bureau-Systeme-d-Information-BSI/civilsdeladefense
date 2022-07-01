import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["recipients"]

  remove(event) {
    this.removeRecipientFromRecipientsList(event.currentTarget)
    this.removeRecipientIdFromEmailForm(event.params.id)
  }

  // private

  removeRecipientFromRecipientsList(target) {
    this.removeFromDOM(target.parentNode)
  }

  removeRecipientIdFromEmailForm(id) {
    this.removeFromDOM(this.findRecipientIdInput(id))
  }

  findRecipientIdInput(id) {
    return this.recipientsTargets.find(input => input.value === id)
  }

  removeFromDOM(target) {
    target.parentNode.removeChild(target)
  }
}
