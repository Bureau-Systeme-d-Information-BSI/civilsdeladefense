const Rails = require('rails-ujs')

document.addEventListener("DOMContentLoaded", function() {
  ;[].forEach.call(document.querySelectorAll('.in-place-edit'), function(el) {
    el.addEventListener('click', function(e) {
      el.classList.add('d-none')
      let form = el.nextElementSibling
      form.classList.remove('d-none')
      ;[].forEach.call(form.querySelectorAll('input[type=text]'), function(inputElement) {
        inputElement.addEventListener('blur', function(e2) {
          Rails.fire(form, 'submit')
        })
      })
      ;[].forEach.call(form.querySelectorAll('select'), function(selectElement) {
        selectElement.addEventListener('change', function(e2) {
          Rails.fire(form, 'submit')
        })
      })
    })
  })

  ;[].forEach.call(document.querySelectorAll('.form-in-place-edit'), function(formElement) {
    formElement.addEventListener("ajax:success", function(event) {
      let detail = event.detail
      let data = detail[0]
      let result = data[0]
      console.log(data)
      let el = formElement.previousElementSibling
      let field = el.getAttribute('data-field')
      let value = data[field]

      let inputText = formElement.querySelector('input[type=text]')
      if (inputText) {
        el.innerHTML = value
      } else {
        let select = formElement.querySelector('select')
        let text = [...select.options].find(option => option.value == value).text
        el.innerHTML = text
      }

      formElement.classList.add('d-none')
      el.classList.remove('d-none')
    })
  })
})
