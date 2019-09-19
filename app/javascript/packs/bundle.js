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
import getLabelsForInputElement from 'js/polyfill-like-labels.js'

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

import manageSendApplicationForm from 'js/manage-send-application-form'
import formAutoSubmit from 'js/form-auto-submit'
window.formAutoSubmit = formAutoSubmit

import $ from 'jquery';
window.jQuery = $;
window.$ = $;

import Popper from 'popper.js'
window.Popper = Popper
require('snackbarjs')
require('bootstrap-material-design')

$('body').bootstrapMaterialDesign()

document.addEventListener('DOMContentLoaded', function() {

  formAutoSubmit()
  manageDropAreas()
  manageSendApplicationForm()

  ;[].forEach.call(document.querySelectorAll('.custom-file-input'), function(el) {
    el.addEventListener('change', function() {
      var input = this
      let fileName = input.value.split('\\').pop()
      let labels = getLabelsForInputElement(input)
      let label = labels[labels.length - 1]
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
