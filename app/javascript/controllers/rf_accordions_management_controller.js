import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['section', 'collapsible']

  collapse() {
    var button = event.currentTarget
    var state = button.getAttribute('aria-expanded')
    if (state == 'true') {
      button.setAttribute('aria-expanded', false)
      this.collapsibleTarget.classList.remove('rf-collapse--expanded')
    } else {
      button.setAttribute('aria-expanded', true)
      this.collapsibleTarget.classList.add('rf-collapse--expanded')
      this.collapsibleTarget.style.setProperty('--collapser', 'none')
      const height = this.collapsibleTarget.offsetHeight
      this.collapsibleTarget.style.setProperty('--collapse', -height + 'px')
      this.collapsibleTarget.style.setProperty('--collapser', '')
    }
  }
}
