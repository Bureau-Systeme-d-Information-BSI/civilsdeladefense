import 'mdn-polyfills/Element.prototype.closest'

import Rails from '@rails/ujs'

export default function inPlaceEdit() {
  ;[].forEach.call(document.querySelectorAll('.in-place-edit'), function(el) {
    let formElement = el.closest('form')
    formElement.addEventListener('ajax:complete', function(event) {
      inPlaceEdit()
      formAutoSubmit()
    })
    el.addEventListener('click', function(e) {
      el.classList.add('d-none')
      let inputElements = el.parentNode.querySelectorAll('input, select')
      ;[].forEach.call(inputElements, function(inputElement) {
        inputElement.classList.remove('d-none')
      })
    })
  })
}
