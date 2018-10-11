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
require('js/file-drop.js')

import $ from 'jquery';
window.jQuery = $;
window.$ = $;

import 'select2'; // globally assign select2 fn to $ element

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

  $('select.filter').select2({
    width: '100%',
    minimumResultsForSearch: Infinity,
    prompt: 'Select',
    allowClear: true
  }).on('select2:unselecting', function(ev) {
    if (ev.params.args.originalEvent) {
      // When unselecting (in multiple mode)
      ev.params.args.originalEvent.stopPropagation();
    } else {
      // When clearing (in single mode)
      $(this).one('select2:opening', function(ev) { ev.preventDefault(); })
    }
  }).on('change', function(e) {
    let form = e.currentTarget.form
    Rails.fire(form, 'submit')
  })

  ;[].forEach.call(document.querySelectorAll('.custom-file-input'), function(el) {
    el.addEventListener('change', function() {
      var input = this
      let fileName = input.value.split('\\').pop()
      let label = input.labels[input.labels.length - 1]
      label.classList.add('selected')
      var labelPlaceholder = label.innerHTML
      label.innerHTML = fileName
      var elementAlreadyExisting = label.parentNode.querySelector('.delete')
      if (elementAlreadyExisting === null) {
        var element = document.createElement('div')
        element.classList.add('delete')
        element.innerHTML = '✕'
        element.addEventListener("click", (e) => {
          if (confirm("Êtes-vous sûr?")) {
            input.value = ''
            input.classList.remove('is-invalid')
            label.classList.remove('selected')
            label.innerHTML = labelPlaceholder
            element.parentNode.removeChild(element)
          }
        })
        label.parentNode.appendChild(element)
      }
    })
  })

  let jobApplicationForm = document.getElementById('new_job_application')
  if (jobApplicationForm !== null) {
    jobApplicationForm.addEventListener("ajax:beforeSend", function(event) {
      let form = event.currentTarget
      let btn = form.querySelector('[type=submit]')
      btn.disabled = true
      var spinner = btn.nextElementSibling
      spinner.classList.remove('invisible')
      spinner.classList.add('visible')
    })
    jobApplicationForm.addEventListener("ajax:complete", function(event) {
      let form = event.currentTarget
      let btn = form.querySelector('[type=submit]')
      btn.disabled = false
      var spinner = btn.nextElementSibling
      spinner.classList.remove('visible')
      spinner.classList.add('invisible')
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

  let jobOffersFilterings = document.getElementById
  ;[].forEach.call(document.querySelectorAll('.job-offers-filtering'), function(el) {
    el.addEventListener("ajax:beforeSend", function(event) {
      var spinner = el.nextElementSibling
      spinner.classList.remove('invisible')
      spinner.classList.add('visible')
    })
    el.addEventListener("ajax:complete", function(event) {
      var spinner = el.nextElementSibling
      spinner.classList.remove('visible')
      spinner.classList.add('invisible')
    })
  })
})

$( document ).ready(function() {
  var alertNotice = document.querySelector('.alert.alert-info')
  if (alertNotice !== null) {
    var msg = alertNotice.innerHTML
    $.snackbar({content: msg})
  }
})

$('#remoteContentModal').on('show.bs.modal', function (event) {
  var link = event.relatedTarget
  var href = link.href
  var modal = $(this)
  Rails.ajax({
    type: "GET",
    url: href,
    success: function(response){
      var content = $(response).find('body').html()
      modal.find('.modal-body').html(content)
      if (link.classList.contains('job-application-modal-link')) {
        manageDropAreas()
      }
    },
    error: function(response){
      console.log("error")
      console.log(response)
    }
  })
})
