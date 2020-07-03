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

require('js/file-drop.js')

import offCanvas from 'js/off-canvas'
import customFileInput from 'js/custom-file-input'
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
  customFileInput()
  offCanvas()
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
