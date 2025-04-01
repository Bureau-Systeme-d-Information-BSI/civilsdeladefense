import { Controller } from "@hotwired/stimulus"
import { autocomplete } from '@algolia/autocomplete-js'

export default class extends Controller {
  static targets = ["city", "county", "countyCode", "countryCode", "postcode", "region"]

  locationChanged(event) {
    // TODO: prefill input
    if (event.target.value.length > 0) {
      const escapedCityLabel = event.target.value.replace(/[.*+?^${}()|[\]\\'"]/g, '\\$&')
      // TODO: SEB escape ô, û, é, è, à, ç, ù, ê, î, ô, û, ë, ï, ñ, ø, ù, ÿ
      const cityElement = document.querySelector(`[data-filterable-as='${escapedCityLabel}']`)
      // TODO: SEB if not found, clear inputs
      const cityId = cityElement.dataset.value
      this.fillInputs(document.querySelector(`#city-${cityId}`).dataset)
    } else {
      this.fillInputs({})
    }
  }

  // private

  fillInputs(dataset) {
    this.cityTarget.value = dataset.name // Ville (Lille)
    this.postcodeTarget.value = dataset.postcode // Code postal (59000)
    this.countyCodeTarget.value = dataset.countyCode // Code département (59)
    this.countyTarget.value = dataset.county // Département (Nord)
    this.regionTarget.value = dataset.region // Region (Hauts-de-France)
    this.countryCodeTarget.value = dataset.countryCode // Pays (fr)
  }

  clearInputs() {
    this.cityTarget.value = ""
    this.postcodeTarget.value = ""
    this.countyCodeTarget.value = ""
    this.countyTarget.value = ""
    this.regionTarget.value = ""
    this.countryCodeTarget.value = ""
  }
}
