import Rails from '@rails/ujs'
import Url from 'domurl'
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  removeRecord(event) {
    let node = event.currentTarget

    let job_offer_actor_node = node.closest('.job-offer-actor')
    let hidden_field = job_offer_actor_node.querySelector('[name$="[_destroy]"]')

    let hidden_value = hidden_field.value
    if (hidden_value === 'true') {
      hidden_field.value = 'false'
      job_offer_actor_node.classList.remove('opacify')
    } else {
      hidden_field.value = 'true'
      job_offer_actor_node.classList.add('opacify')
    }
    event.preventDefault()
  }

  addFields(event) {
    debugger
    let node = event.currentTarget
    let emailField = node.previousElementSibling.querySelector('input[type=email]')
    if (emailField == null) {
      emailField = node.previousElementSibling.querySelector('select')
    }
    let email = emailField.value
    let url = node.getAttribute('data-url')
    let u = new Url(url)
    u.query.email = email
    url = u.toString()
    Rails.ajax({
      type: 'GET',
      url: url,
      beforeSend: function() {
        let formGroup = emailField.closest('.form-group')
        formGroup.classList.remove('form-group-invalid')
        ;[].forEach.call(formGroup.querySelectorAll('.invalid-feedback'), function(el) {
          formGroup.removeChild(el)
        })
        emailField.classList.remove('is-invalid')
        return true
      },
      success: function(response){
        let content = response.querySelector('form').innerHTML
        let fieldList = node.closest('.form-actor').previousElementSibling
        fieldList.insertAdjacentHTML('afterend', content)
        emailField.value = ''
      },
      error: function(response){
        let message = response.email.join(', ')
        emailField.closest('.form-group').classList.add('form-group-invalid')
        emailField.classList.add('is-invalid')
        emailField.insertAdjacentHTML('afterend', `<div class=\'invalid-feedback\'>${message}</div>`)
      }
    })
    event.preventDefault()
  }
}
