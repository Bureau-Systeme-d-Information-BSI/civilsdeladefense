var places = require('places.js')

export default function addressAutocomplete() {
  ;[].forEach.call(document.querySelectorAll('[name$="[address]"]'), function(locationNode) {
    var placesAutocomplete = places({
      appId: 'pl1XE8SNQ8DY',
      apiKey: '734672b37e8837cdbe0106851d7fbe18',
      container: locationNode,
      language: 'fr',
      countries: ['fr'],
      type: 'address',
      aroundLatLngViaIP: false,
      useDeviceLocation: false
    })

    var inputBaseName = locationNode.name

    placesAutocomplete.on('change', function resultSelected(e) {
      var inputName = inputBaseName.replace('[address]', '[address_1]')
      document.querySelector(`[name="${inputName}"]`).value = e.suggestion.name || ''

      var inputName = inputBaseName.replace('[address]', '[city]')
      document.querySelector(`[name="${inputName}"]`).value = e.suggestion.city || ''

      var inputName = inputBaseName.replace('[address]', '[country]')
      document.querySelector(`[name="${inputName}"]`).value = e.suggestion.countryCode || ''

      var inputName = inputBaseName.replace('[address]', '[postcode]')
      document.querySelector(`[name="${inputName}"]`).value = e.suggestion.postcode || ''
    })
  })
}
