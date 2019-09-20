import Rails from 'rails-ujs'

function preventDefaults (e) {
  e.preventDefault()
  e.stopPropagation()
}

function highlight (e) {
  e.currentTarget.classList.add('highlight')
}

function unhighlight (e) {
  e.currentTarget.classList.remove('highlight')
}

function handleDrop(e) {
  let dt = e.dataTransfer
  let files = dt.files
  let form = e.currentTarget.closest('form')
  let input = form.querySelector('input[type=file]')

  input.files = files
  Rails.fire(form, 'submit')
}

function manageDropArea (dropArea) {
  ;['dragenter', 'dragover', 'dragleave', 'drop'].forEach((eventName) => {
    dropArea.addEventListener(eventName, preventDefaults, false)
  })

  ;['dragenter', 'dragover'].forEach(eventName => {
    dropArea.addEventListener(eventName, highlight, false)
  })

  ;['dragleave', 'drop'].forEach(eventName => {
    dropArea.addEventListener(eventName, unhighlight, false)
  })

  dropArea.addEventListener('drop', handleDrop, false)
}

window.manageDropArea = manageDropArea

function manageDropAreas () {
  var elements = document.querySelectorAll('.drop-area')
  ;[].forEach.call(elements, function(dropArea) {
    manageDropArea(dropArea)
  })
}

window.manageDropAreas = manageDropAreas
