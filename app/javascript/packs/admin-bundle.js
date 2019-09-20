/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Turbolinks from 'turbolinks'
Turbolinks.start()

import Url from 'domurl'
import flatpickr from 'flatpickr'
import { French } from 'flatpickr/dist/l10n/fr'
import Lightpick from 'lightpick'
import moment from 'moment'
import $ from 'jquery'
window.jQuery = $
window.$ = $

import 'select2' // globally assign select2 fn to $ element

import Popper from 'popper.js'
window.Popper = Popper
require('snackbarjs')
require('bootstrap-material-design')
import Highcharts from 'highcharts'
Highcharts.setOptions({
  lang: {
    loading: 'Chargement...',
    months: ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'],
    weekdays: ['dimanche', 'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi'],
    shortMonths: ['jan', 'fév', 'mar', 'avr', 'mai', 'juin', 'juil', 'août', 'sep', 'oct', 'nov', 'déc'],
    exportButtonTitle: "Exporter",
    printButtonTitle: "Imprimer",
    rangeSelectorFrom: "Du",
    rangeSelectorTo: "au",
    rangeSelectorZoom: "Période",
    downloadPNG: 'Télécharger en PNG',
    downloadJPEG: 'Télécharger en JPEG',
    downloadPDF: 'Télécharger en PDF',
    downloadSVG: 'Télécharger en SVG',
    resetZoom: "Réinitialiser le zoom",
    resetZoomTitle: "Réinitialiser le zoom",
    thousandsSep: " ",
    decimalPoint: ','
  }
});

const Rails = require('rails-ujs')
Rails.start()

// Import TinyMCE
import tinymce from 'tinymce/tinymce'
// A theme is also required
import 'tinymce/themes/silver/theme'
// Any plugins you want to use has to be imported
import 'tinymce/plugins/paste'
import 'tinymce/plugins/link'
import 'tinymce/plugins/lists'

function importAll(r) {
  return r.keys().map(r)
}

importAll(require.context('images/', true, /\.(ico|png|jpe?g|svg|gif)$/))
importAll(require.context('icons/', true, /\.svg$/))

require('js/offcanvas.js')
require('js/dependent-fields.js')
require('js/board.js')
require('js/city-autocomplete.js')

import salaryRangeInputsHandling from 'js/salary-range-inputs-handling'
import addressAutocomplete from 'js/address-autocomplete'
window.addressAutocomplete = addressAutocomplete
import formAutoSubmit from 'js/form-auto-submit'
window.formAutoSubmit = formAutoSubmit
import inPlaceEdit from 'js/in-place-edit'
window.inPlaceEdit = inPlaceEdit

$('body').bootstrapMaterialDesign()

document.addEventListener('turbolinks:load', function() {
  tinymce.init({
    selector: '.ckeditor',
    branding: false,
    menubar: false,
    height: 300,
    toolbar: 'undo redo | paste | bold italic link | bullist numlist',
    plugins: ['paste', 'lists']
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
        var fields = button.closest('.form-actor').prev()
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

  $('.new_preferred_user, .edit_preferred_user').on('ajax:success', function(event) {
    let detail = event.detail
    let xhr = detail[2]
    let redirect_url = xhr.getResponseHeader('Location')
    if (redirect_url != undefined) {
      window.location.href = redirect_url
    }
  }).on('ajax:error', function(event) {
    let detail = event.detail
    let data = detail[0]
    var content = $(data).find('body').html()
    modal.find('.modal-body').html(content)
  })

  $('#remoteContentModal').on('show.bs.modal', function (event) {
    var link = event.relatedTarget
    if (link !== undefined) {
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
          formAutoSubmit()
          inPlaceEdit()
          addressAutocomplete()
          $('.new_preferred_users_list, .edit_preferred_users_list').on('ajax:success', function(event) {
            let detail = event.detail
            let xhr = detail[2]
            let redirect_url = xhr.getResponseHeader('Location')
            if (redirect_url != undefined) {
              window.location.href = redirect_url
            }
          }).on('ajax:error', function(event) {
            let detail = event.detail
            let data = detail[0]
            var content = $(data).find('body').html()
            modal.find('.modal-body').html(content)
          })
        },
        error: function(response){
          console.log("error")
          console.log(response)
        }
      })
    }
  })
})

document.addEventListener('turbolinks:load', function() {
  ;[].forEach.call(document.querySelectorAll('.input-search'), function(inputSearchNode) {
    inputSearchNode.addEventListener('click', function(e) {
    })
  })
  formAutoSubmit()
  inPlaceEdit()
  addressAutocomplete()
  salaryRangeInputsHandling()

  var perDayChartNode = document.getElementById('per-day-graph')
  if (perDayChartNode !== null && perDayData !== undefined) {
    const perDayChart = Highcharts.chart(perDayChartNode, {
      height: '200px',
      chart: {
        styledMode: true
      },
      title: {
        text: null
      },
      credits: {
        enabled: false
      },
      tooltip: {
        crosshairs: true
      },
      legend: {
        enabled: false
      },
      xAxis: {
        type: 'datetime'
      },
      yAxis: {
        allowDecimals: false,
        legend: {
          enable: false
        },
        title: {
          text: null
        }
      },
      series: [{
        type: 'column',
        name: 'Nombre de candidatures',
        data: perDayData.map(function(point) {
          return [
            new Date(point[0]).getTime(),
            point[1]
          ];
        })
      }]
    })
  }

  var date_start_node = document.getElementById('date_start')
  var date_end_node = document.getElementById('date_end')
  if ((date_start_node !== null) && (date_end_node !== null)) {
    new Lightpick({
      field: document.getElementById('date_start'),
      secondField: document.getElementById('date_end'),
      singleDate: false,
      numberOfColumns: 2,
      numberOfMonths: 2,
      maxDate: moment(),
      onClose: function() {
        var start = this._opts.startDate
        var end = this._opts.endDate
        var path = window.location.href;

        var newURL = window.location.protocol + "//" + window.location.host + "/" + window.location.pathname
        newURL += '?' + 'start=' + start.format('YYYYMMDD') + '&end=' + end.format('YYYYMMDD')

        window.location.href = newURL
      }
    })
  }
})


