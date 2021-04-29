import Rails from '@rails/ujs'
import Url from 'domurl'

export default function jobOfferManagement() {
  ;[].forEach.call(document.querySelectorAll('.new_job_offer, .edit_job_offer'), function(formNode) {

    //remove Actor
    ;[].forEach.call(formNode.querySelectorAll('.remove_record'), function(node) {
      node.addEventListener('click', function(event) {
        var hidden_field, hidden_value, job_offer_actor_node
        job_offer_actor_node = node.closest('.job-offer-actor')
        hidden_field = job_offer_actor_node.querySelector('[name$="[_destroy]"]')
        hidden_value = hidden_field.value
        if (hidden_value === 'true') {
          hidden_field.value = 'false'
          job_offer_actor_node.classList.remove('opacify')
        } else {
          hidden_field.value = 'true'
          job_offer_actor_node.classList.add('opacify')
        }
        return event.preventDefault()
      })
    })

    //add Actor
    ;[].forEach.call(formNode.querySelectorAll('.add_fields'), function(node) {
      node.addEventListener('click', function(event) {
        var url, emailField, email, button
        button = node
        emailField = button.previousElementSibling.querySelector('input[type=email]')
        if (emailField == null) {
          emailField = button.previousElementSibling.querySelector('select')
        }
        email = emailField.value
        url = node.getAttribute('data-url')
        var u = new Url(url)
        u.query.email = email
        url = u.toString()
        Rails.ajax({
          type: 'GET',
          url: url,
          beforeSend: function() {
            var formGroup = emailField.closest('.form-group')
            formGroup.classList.remove('form-group-invalid')
            ;[].forEach.call(formGroup.querySelectorAll('.invalid-feedback'), function(el) {
              formGroup.removeChild(el)
            })
            emailField.classList.remove('is-invalid')
            return true
          },
          success: function(response){
            var content = response.querySelector('form').innerHTML
            var fieldList = button.closest('.form-actor').previousElementSibling
            fieldList.insertAdjacentHTML('afterend', content)
            emailField.value = ''
          },
          error: function(response){
            var message
            message = response.email.join(', ')
            emailField.closest('.form-group').classList.add('form-group-invalid')
            emailField.classList.add('is-invalid')
            emailField.insertAdjacentHTML('afterend', `<div class=\'invalid-feedback\'>${message}</div>`)
          }
        })
        return event.preventDefault()
      })
    })
  })
}
