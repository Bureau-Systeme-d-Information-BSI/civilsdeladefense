import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["city", "county", "countyCode", "countryCode", "postcode", "region", "location", "locationSearch"]

  connect() {
    document.addEventListener("hw-combobox:selection", (event) => {
      if (event.detail.query.length > 0) {
        this.fillInputs(event.detail.value, event.detail.display)
      } else {
        this.clearInputs()
      }
    })
  }

  // private

  fillInputs(id, query) {
    const url = `/admin/cities/${id}`
    const searchParams = new URLSearchParams()
    searchParams.append("q", query.split(",")[0])

    fetch(`${url}?${searchParams}`)
      .then((response) => response.json())
      .then((data) => {
        const splittedContext = data.context.split(", ")
        this.locationTarget.value = `${data.city}, ${data.context}` // Ville, Département, Région
        this.cityTarget.value = data.city // Ville (Lille)
        this.postcodeTarget.value = data.postcode // Code postal (59000)
        this.countyCodeTarget.value = splittedContext[0] // Code département (59)
        this.countyTarget.value = splittedContext[1] // Département (Nord)
        this.regionTarget.value = splittedContext[2] // Region (Hauts-de-France)
        this.countryCodeTarget.value = "fr" // Pays (fr)
      })
  }

  clearInputs() {
    this.locationTarget.value = ""
    this.cityTarget.value = ""
    this.postcodeTarget.value = ""
    this.countyCodeTarget.value = ""
    this.countyTarget.value = ""
    this.regionTarget.value = ""
    this.countryCodeTarget.value = ""
  }
}
