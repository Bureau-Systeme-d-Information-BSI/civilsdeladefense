import autocompleteJS from "autocomplete.js"
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "query", "city", "county", "countyCode", "countryCode", "postcode", "region",
  ]

  initialize() {
    autocompleteJS(
      this.queryTarget,
      { hint: false },
      [{
        source: (query, callback) => this.getSuggestions(query, callback),
        name: "autocomplete-geo",
        templates: {
          suggestion: this.suggestionTemplate,
          empty: this.emptyTemplate
        },
        displayKey: (suggestion) => `${suggestion.properties.label}, ${suggestion.properties.context}`,
        debounce: 300
      }]
    ).on(
      "autocomplete:selected",
      (event, suggestion, dataset) => this.fillInput(event, suggestion, dataset)
    );
  }

  getSuggestions(query, callback) {
    const url = "https://api-adresse.data.gouv.fr/search/"
    const searchParams = new URLSearchParams()
    searchParams.append("q", query)
    searchParams.append("type", "municipality")

    fetch(
      `${url}?${searchParams}`
    ).then(
      res => res.json()
    ).then(
      res => this.formatData(res)
    ).then(
      res => callback(res)
    ).catch(
      ex => console.log("fetch failed", ex)
    )
  }

  formatData(json) {
    return json.features
  }

  suggestionTemplate(suggestion) {
    const city = suggestion.properties.label
    const context = suggestion.properties.context
    return `<span class="font-weight-bold">${city}</span>, <span class="">${context}</span>`;
  }

  emptyTemplate() {
    return '<div class="aa-empty">Aucun résultat</div>'
  }

  fillInput(event, suggestion, dataset) {
    const properties = suggestion.properties
    const context = suggestion.properties.context.split(", ") // 59, Nord, Hauts-de-France

    this.cityTarget.value = properties.city // Ville (Lille)
    this.postcodeTarget.value = properties.postcode // Code postal (59000)
    this.countyCodeTarget.value = context[0] // Code département (59)
    this.countyTarget.value = context[1] // Département (Nord)
    this.regionTarget.value = context[2] // Region (Hauts-de-France)
    this.countryCodeTarget.value = "fr" // Pays (fr)
  }
}
