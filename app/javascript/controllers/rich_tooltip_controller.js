import { Controller } from "@hotwired/stimulus"

// Use the BSN JavaScript API to let the tooltip title contain HTML, in order to show rich tooltips
// https://thednp.github.io/bootstrap.native/#tooltipOptions

export default class extends Controller {
  connect() {
    new BSN.Tooltip(this.element, {})
  }
}
