var places = require('places.js')

export default function cityAutocomplete() {
  var locationNode = document.querySelector('#job_offer_location')
  if (locationNode) {
    var placesAutocomplete = places({
      appId: 'pl1XE8SNQ8DY',
      apiKey: '734672b37e8837cdbe0106851d7fbe18',
      container: locationNode,
      language: 'fr',
      countries: ['fr'],
      type: 'city',
      aroundLatLngViaIP: false
    })

    placesAutocomplete.on('change', function resultSelected(e) {
      document.querySelector('#job_offer_city').value = e.suggestion.name || ''
      document.querySelector('#job_offer_county').value = e.suggestion.county || ''
      var postcode = e.suggestion.postcode || ''
      if (postcode !== '') {
        var countyCode = Math.trunc(e.suggestion.postcode / 1000)
        document.querySelector('#job_offer_county_code').value = countyCode || ''
      }
      document.querySelector('#job_offer_country_code').value = e.suggestion.countryCode || ''
      document.querySelector('#job_offer_postcode').value = postcode || ''
      document.querySelector('#job_offer_region').value = e.suggestion.administrative || ''
    })
  }
}
