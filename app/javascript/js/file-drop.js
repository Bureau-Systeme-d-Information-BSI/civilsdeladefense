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
  let url = form.getAttribute('action')
  let input = form.querySelector('input[type=file]')
  let inputName = input.getAttribute('name')

  handleFiles(url, inputName, files)
}

function uploadFile(url, inputName, file) {
  let formData = new FormData()
  formData.append(inputName, file)

  Rails.ajax({
    type: 'PATCH',
    url: url,
    dataType: 'script',
    data: formData,
    success: (response) => {
    },
    error: (response) => {
      console.log("error")
      console.log(response)
    }
  })
}

function handleFiles(url, inputName, files) {
  ([...files]).forEach((file) => {
    uploadFile(url, inputName, file)
  })
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

  let form = dropArea.closest('form')
  let url = form.getAttribute('action')
  let input = form.querySelector('input[type=file]')
  let inputName = input.getAttribute('name')

  input.addEventListener('change', (e) => {
    handleFiles(url, inputName, input.files)
  }, false)
}

window.manageDropArea = manageDropArea

let dropAreas = document.querySelectorAll('.drop-area')
dropAreas.forEach(dropArea => {
  manageDropArea(dropArea)
})

