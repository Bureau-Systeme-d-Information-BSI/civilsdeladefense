import { Controller } from "@hotwired/stimulus"
import { autocomplete } from '@algolia/autocomplete-js'

export default class extends Controller {
  static targets = [
    "query", "city", "county", "countyCode", "countryCode", "postcode", "region", "location"
  ]

  initialize() {
    autocomplete({
      container: this.queryTarget,
      placeholder: 'Chercher un lieu',
      detachedMediaQuery: '',
      translations: {
        clearButtonTitle: "Effacer",
        submitButtonTitle: ""
      },
      getSources: ({ query }) => this.getSources(query)
    })
  }

  search() {
    this.queryTarget.querySelector("button").click()
  }

  getSources(query) {
    const url = "https://api-adresse.data.gouv.fr/search/"
    const searchParams = new URLSearchParams()
    searchParams.append("q", query)
    searchParams.append("type", "municipality")

    return fetch(`${url}?${searchParams}`)
      .then((response) => response.json())
      .then((json) => json.features)
      .then((data) => {
        return [
          {
            sourceId: `adresses`,
            getItems: () => data,
            templates: {
              item: ({ item, html }) => this.templateItem(item, html),
              noResults: () => 'Aucun résultat',
            },
            onSelect: ({ item }) => this.fillInputs(item),
          },
        ];
      })
      .catch((ex) => console.log("fetch failed", ex))
  }

  templateItem(item, html) {
    return html`<div class="aa-ItemWrapper">
      <div class="aa-ItemContent">
        <div class="aa-ItemContentBody">
          <span class="aa-ItemContentTitle">
            ${item.properties.label}
          </span>
          <span class="aa-ItemContentDescription">
            ${item.properties.context}
          </span>
        </div>
      </div>
    </div>`
  }

  fillInputs(item) {
    const properties = item.properties
    const context = item.properties.context
    const splittedContext = item.properties.context.split(", ") // 59, Nord, Hauts-de-France

    this.locationTarget.value = `${item.properties.label}, ${context}`
    this.cityTarget.value = properties.city // Ville (Lille)
    this.postcodeTarget.value = properties.postcode // Code postal (59000)
    this.countyCodeTarget.value = splittedContext[0] // Code département (59)
    this.countyTarget.value = splittedContext[1] // Département (Nord)
    this.regionTarget.value = splittedContext[2] // Region (Hauts-de-France)
    this.countryCodeTarget.value = "fr" // Pays (fr)

    // this.clearSearch()
  }

  clearSearch() {
    var clearButton = this.queryTarget.querySelector(".aa-ClearButton")
    if (clearButton) {
      clearButton.click()
    }
  }
}
