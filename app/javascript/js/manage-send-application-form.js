import 'mdn-polyfills/Element.prototype.closest'
import smoothscroll from 'smoothscroll-polyfill'
smoothscroll.polyfill()

import Rails from '@rails/ujs'

function cleanupInvalidFields () {
  ;[].forEach.call(document.querySelectorAll('.invalid-feedback'), function(el) {
    el.parentNode.removeChild(el)
  })
  ;[].forEach.call(document.querySelectorAll('.form-group-invalid'), function(el) {
    el.classList.remove('form-group-invalid')
  })
  ;[].forEach.call(document.querySelectorAll('.is-invalid'), function(el) {
    el.classList.remove('is-invalid')
  })
}

export default function manageSendApplicationForm() {
  let jobApplicationForm = document.getElementById('new_job_application')
  if (jobApplicationForm !== null) {
    jobApplicationForm.addEventListener("ajax:beforeSend", function(event) {
      let form = event.currentTarget
      let btn = form.querySelector('[type=submit]')
      btn.disabled = true
      var spinners = form.querySelectorAll('.spinner')
      ;[].forEach.call(spinners, function(spinner) {
        spinner.classList.remove('invisible')
      })
    })
    jobApplicationForm.addEventListener("ajax:complete", function(event) {
      let form = event.currentTarget
      let btn = form.querySelector('[type=submit]')
      btn.disabled = false
      var spinners = form.querySelectorAll('.spinner')
      ;[].forEach.call(spinners, function(spinner) {
        spinner.classList.add('invisible')
      })
    })
    jobApplicationForm.addEventListener("ajax:success", function(event) {
      let detail = event.detail
      let data = detail[0]
      let status = detail[1]
      let xhr = detail[2]
      let redirect_url = xhr.getResponseHeader('Location')
      if (redirect_url != undefined) {
        window.location.href = redirect_url
      }
    })
    jobApplicationForm.addEventListener("ajax:error", function(event) {
      let detail = event.detail
      let data = detail[0]
      cleanupInvalidFields()
      for (var p in data) {
        if( data.hasOwnProperty(p) ) {
          let newP = p.replace('[', '_attributes_')
          newP = newP.replace('].', '_')
          newP = newP.replace('.', '_attributes_')
          let id = `job_application_${ newP }`
          let node = document.getElementById(id)
          if (node !== null) {
            node.closest('.form-group').classList.add('form-group-invalid')
            node.classList.add('is-invalid')
            node.insertAdjacentHTML('afterend', `<div class=\'invalid-feedback\'>${data[p].join(', ')}</div>`)
          }
        }
      }
      let el = document.querySelector('.form-group-invalid')
      if (el !== null) {
        el.scrollIntoView({ behavior: 'smooth' })
      }
    })
  }
}
