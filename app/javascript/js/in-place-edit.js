const Rails = require('rails-ujs')

export default function inPlaceEdit() {
  ;[].forEach.call(document.querySelectorAll('.in-place-edit'), function(el) {
    let formElement = el.closest('form')
    formElement.addEventListener('ajax:complete', function(event) {
      inPlaceEdit()
      addressAutocomplete()
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
