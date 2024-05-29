import { Controller } from "@hotwired/stimulus"
import { autocomplete } from '@algolia/autocomplete-js'

export default class extends Controller {
  static targets = ["query", "city", "postalCode", "address"]

  initialize() {
    autocomplete({
      container: this.queryTarget,
      placeholder: 'Chercher une adresse',
      detachedMediaQuery: '',
      translations: {
        clearButtonTitle: "Effacer",
        detachedCancelButtonText: "Annuler",
        submitButtonTitle: ""
      },
      getSources: ({ query }) => this.getSources(query)
    })
  }

  search() {
    this.queryTarget.querySelector("button").click()
  }

  getSources(query) {
    if (query.length < 3) {
      return []
    }

    const url = "https://api-adresse.data.gouv.fr/search/"
    const searchParams = new URLSearchParams()
    searchParams.append("q", query)

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
        ]
      })
      .catch((ex) => {
        return []
      })
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

    this.addressTarget.value = properties.name
    this.cityTarget.value = properties.city
    this.postalCodeTarget.value = properties.postcode
  }

  clearSearch() {
    const clearButton = this.queryTarget.querySelector(".aa-ClearButton")
    if (clearButton) {
      clearButton.click()
    }
  }
}
