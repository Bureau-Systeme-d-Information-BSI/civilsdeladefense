import { Controller } from "@hotwired/stimulus"
import { autocomplete } from '@algolia/autocomplete-js'

export default class extends Controller {
  static targets = [
    "city", "county", "countyCode", "countryCode", "postcode", "region", "location"
  ]

  locationChanged(event) {
    const cityLabel = event.target.value
    const cityId = document.querySelector(`[data-filterable-as='${cityLabel}']`).dataset.value
    this.fillInputs(document.querySelector(`#city-${cityId}`).dataset)
  }

  fillInputs(dataset) {
    this.cityTarget.value = dataset.name // Ville (Lille)
    this.postcodeTarget.value = dataset.postcode // Code postal (59000)
    this.countyCodeTarget.value = dataset.countyCode // Code département (59)
    this.countyTarget.value = dataset.county // Département (Nord)
    this.regionTarget.value = dataset.region // Region (Hauts-de-France)
    this.countryCodeTarget.value = dataset.countryCode // Pays (fr)
  }

  clearSearch() {
    var clearButton = this.queryTarget.querySelector(".aa-ClearButton")
    if (clearButton) {
      clearButton.click()
    }
  }
}
