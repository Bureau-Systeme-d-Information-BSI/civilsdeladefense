import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"
import { FetchRequest } from '@rails/request.js'

export default class extends Controller {
  static values = { url: String }

  connect() {
    new Sortable(this.element, {
      animation: 150,
      handle: ".grabbable",
      ghostClass: "grabbed",
      direction: "vertical",
      onEnd: this.persistNewPosition
    })
  }

  // Private

  persistNewPosition = (event) => {
    const newIndex = event.newIndex

    const url = "/admin/parametres/positions"
    const data = new FormData
    data.append("position", newIndex + 1)
    data.append("resource_class", event.item.getAttribute("data-resource-class"))
    data.append("resource_id", event.item.getAttribute("data-id"))
    const request = new FetchRequest('patch', url, { body: data, responseKind: 'js' })
    const response = request.perform()
    if (response.ok) {
      window.location.reload()
    }
  }
}
