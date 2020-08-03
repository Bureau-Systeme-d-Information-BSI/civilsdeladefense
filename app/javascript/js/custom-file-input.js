import getLabelsForInputElement from 'js/polyfill-like-labels.js'

export default function customFileInput() {
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
}