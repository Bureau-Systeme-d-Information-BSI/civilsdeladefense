/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Url from 'domurl'
import flatpickr from 'flatpickr'
import { French } from "flatpickr/dist/l10n/fr"
import $ from 'jquery'
window.jQuery = $
window.$ = $

import 'select2' // globally assign select2 fn to $ element

import Popper from 'popper.js'
window.Popper = Popper
require('snackbarjs')
require('bootstrap-material-design')

const Rails = require('rails-ujs')
Rails.start()

import ClassicEditor from '@ckeditor/ckeditor5-build-classic'
import '@ckeditor/ckeditor5-build-classic/build/translations/fr.js'

document.querySelectorAll('.ckeditor').forEach((node) => {
  ClassicEditor
    .create(node, {
      toolbar: [ 'bold', 'italic', 'link', 'bulletedList', 'numberedList' ],
      language: 'fr',
    })
    .then( editor => {
        console.log( editor )
    })
    .catch( error => {
        console.error( error )
    })
})

function importAll(r) {
  return r.keys().map(r)
}

importAll(require.context('images/', true, /\.(ico|png|jpe?g|svg|gif)$/))
importAll(require.context('icons/', true, /\.svg$/))

require('js/offcanvas.js')
require('js/dependent-fields.js')
require('js/in-place-edit.js')
require('js/board.js')

$('body').bootstrapMaterialDesign()

$( document ).ready(function() {
  var reactiveElements = ['job_offer_professional_category_id', 'job_offer_experience_level_id', 'job_offer_sector_id']
  var reactiveElementsSelector = reactiveElements.map(item => `#${item}`).join(', ')
  ;[].forEach.call(document.querySelectorAll(reactiveElementsSelector), function(el) {
    el.addEventListener("ajax:before", function(event) {
      let form = event.currentTarget
      let dataStr = reactiveElements.filter(item => item.id !== form.id).map(item => {
        var element = document.getElementById(item)
        return Rails.serializeElement(element)
      }).join('&')
      form.setAttribute('data-params', dataStr)
    })
    el.addEventListener("ajax:success", function(event) {
      let detail = event.detail
      let data = detail[0]
      let result = data[0]
      let element = document.getElementById('job_offer_estimate_monthly_salary_net')
      if (result) {
        var estimateMonthlySalaryNet = result.estimate_monthly_salary_net
        if ((!element.value) || (!element.defaultValue)) {
          element.value = estimateMonthlySalaryNet
        }
        let elementHint = document.querySelector('.estimate_monthly_salary_net_reference')
        elementHint.innerHTML = estimateMonthlySalaryNet
      }
      element = document.getElementById('job_offer_estimate_annual_salary_gross')
      if (result) {
        var estimateAnnualSalaryGross = result.estimate_annual_salary_gross
        if ((!element.value) || (!element.defaultValue)) {
          element.value = estimateAnnualSalaryGross
        }
        let elementHint = document.querySelector('.estimate_annual_salary_gross_reference')
        elementHint.innerHTML = estimateAnnualSalaryGross
      }
    })
  })
  $('select.filter').select2({
    width: '100%',
    minimumResultsForSearch: Infinity,
    prompt: 'Select',
    allowClear: true
  }).on('select2:unselecting', function(ev) {
    if (ev.params.args.originalEvent) {
      // When unselecting (in multiple mode)
      ev.params.args.originalEvent.stopPropagation()
    } else {
      // When clearing (in single mode)
      $(this).one('select2:opening', function(ev) { ev.preventDefault() })
    }
  }).on('change', function(e) {
    let form = e.currentTarget.form
    Rails.fire(form, 'submit')
  })

  var alertNotice = document.querySelector('.alert.alert-info')
  if (alertNotice !== null) {
    var msg = alertNotice.innerHTML
    $.snackbar({content: msg})
  }

  $('.custom-file-input').on('change', function() {
    let fileName = $(this).val().split('\\').pop()
    $(this).next('.custom-file-label').addClass("selected").html(fileName)
  })

  flatpickr("#job_offer_contract_start_on", {
    locale: French,
    altInput: true,
    altFormat: "d/m/Y",
    dateFormat: "Y-m-d"
  })

  $('.new_job_offer, .edit_job_offer').on('click', '.remove_record', function(event) {
    var hidden_field, hidden_value, job_offer_actor_node
    job_offer_actor_node = $(this).closest('.job-offer-actor')
    hidden_field = job_offer_actor_node.find('[name$="[_destroy]"]')
    hidden_value = hidden_field.val()
    if (hidden_value === '1') {
      hidden_field.val('0')
      $(job_offer_actor_node).removeClass('opacify')
    } else {
      hidden_field.val('1')
      $(job_offer_actor_node).addClass('opacify')
    }
    return event.preventDefault()
  });

  $('.new_job_offer, .edit_job_offer').on('click', '.add_fields', function(event) {
    var url, emailField, email, button
    button = $(event.currentTarget)
    emailField = button.prev().find('input[type=email]').get(0)
    email = emailField.value
    url = $(this).data('url')
    var u = new Url(url)
    u.query.email = email
    url = u.toString()
    Rails.ajax({
      type: "GET",
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
        var content = $(response).find('form').html()
        console.log('************')
        console.log(content)
        var fields = button.closest('.form-actor').prev()
        console.log(fields)
        var fields = fields.append(content)
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

document.addEventListener("DOMContentLoaded", function() {
  var inputSearchNodes = document.querySelectorAll('.input-search')
  if (inputSearchNodes !== null) {
    inputSearchNodes.forEach( (inputSearchNode) => {
      inputSearchNode.addEventListener('click', function(e) {
      })
    })
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
        initEmailTemplates()
      }
    },
    error: function(response){
      console.log("error")
      console.log(response)
    }
  })
})

