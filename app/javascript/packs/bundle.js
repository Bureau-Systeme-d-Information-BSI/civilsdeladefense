/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

const Rails = require('rails-ujs')
Rails.start()

import 'mdn-polyfills/Element.prototype.closest'

import smoothscroll from 'smoothscroll-polyfill'
// kick off the polyfill!
smoothscroll.polyfill()

function importAll(r) {
  return r.keys().map(r)
}

importAll(require.context('images/', true, /\.(ico|png|jpe?g|svg|gif)$/))
importAll(require.context('icons/', true, /\.svg$/))

require('js/offcanvas.js')

import $ from 'jquery';
window.jQuery = $;
window.$ = $;

import Popper from 'popper.js'
window.Popper = Popper
require('snackbarjs')
require('bootstrap-material-design')

$('body').bootstrapMaterialDesign()

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

document.addEventListener("DOMContentLoaded", function() {

  [].forEach.call(document.querySelectorAll('.custom-file-input'), function(el) {
    el.addEventListener('change', function() {
      let fileName = this.value.split('\\').pop()
      let label = this.nextElementSibling
      label.classList.add("selected")
      label.innerHTML = fileName
    })
  })

  let jobApplicationForm = document.getElementById('new_job_application')
  if (jobApplicationForm !== null) {
    document.addEventListener("ajax:beforeSend", function(event) {
      let form = event.currentTarget
      let btn = form.querySelector('[type=submit]')
      btn.disabled = true
    })
    document.addEventListener("ajax:complete", function(event) {
      let form = event.currentTarget
      let btn = form.querySelector('[type=submit]')
      btn.disabled = false
    })
    document.addEventListener("ajax:success", function(event) {
      let detail = event.detail
      let data = detail[0]
      let status = detail[1]
      let xhr = detail[2]
      let redirect_url = xhr.getResponseHeader('Location')
      if (redirect_url != undefined) {
        window.location.href = redirect_url
      }
    })
    document.addEventListener("ajax:error", function(event) {
      let detail = event.detail
      let data = detail[0]
      cleanupInvalidFields()
      for (var p in data) {
        if( data.hasOwnProperty(p) ) {
          let id = `job_application_${ p.replace('.', '_attributes_') }`
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
})
