const Rails = require('rails-ujs')

export default function formAutoSubmit() {
  ;[].forEach.call(document.querySelectorAll('form.auto-submit'), function(formElement) {
    var selectElements = formElement.querySelectorAll('select')
    ;[].forEach.call(selectElements, function(selectElement) {
      selectElement.addEventListener('change', function(e) {
        Rails.fire(formElement, 'submit')
      })
    })

    var textElements = formElement.querySelectorAll('input[type=text]')
    ;[].forEach.call(textElements, function(inputElement) {
      inputElement.addEventListener('blur', function(e) {
        Rails.fire(formElement, 'submit')
      })
    })

    var fileInputs = formElement.querySelectorAll("input[type=file]")
    ;[].forEach.call(fileInputs, function(inputElement) {
      inputElement.addEventListener('change', function(e) {
        Rails.fire(formElement, 'submit')
      })
    })
  })
}
