import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static values = { url: String }

  connect() {
    new Sortable(this.element, {
      animation: 150,
      handle: ".grabbable",
      ghostClass: "grabbed",
      direction: "vertical"
      // onEnd: this.persistNewPosition
    })
  }

  // Private

  persistNewPosition = (event) => {
    const newIndex = event.newIndex
    const url = event.item.getAttribute("data-quote-item--sortable-url-value")
    const data = new FormData
    data.append("position", newIndex + 1)

    patch(url, { body: data, responseKind: "turbo-stream" }).then(response => {
      if (!response.ok) {
        window.location.reload()
      }
    })
  }
}
