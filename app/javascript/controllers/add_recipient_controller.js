import { Controller } from "@hotwired/stimulus"
import { autocomplete } from '@algolia/autocomplete-js'

export default class extends Controller {
  static values = { searchUrl: String }
  static targets = ["recipients", "autocomplete", "newRecipientForm", "newRecipientId"]

  connect() {
    autocomplete({
      container: this.autocompleteTarget,
      placeholder: 'Ajouter un·e destinataire',
      detachedMediaQuery: 'none',
      translations: {
        clearButtonTitle: "Effacer",
        submitButtonTitle: ""
      },
      getSources: ({ query }) => this.getSources(query)
    })
  }

  // private

  getSources(query) {
    return fetch(`${this.searchUrlValue}?s=${query}`)
      .then((response) => response.json())
      .then((data) => {
        return [
          {
            sourceId: `recipients`,
            getItems: () => data,
            templates: {
              item: ({ item, html }) => this.templateItem(item, html),
            },
            onSelect: ({ item }) => this.add(item),
          },
        ]
      })
  }

  add(recipient) {
    if (!this.findRecipientIdInput(recipient.id)) {
      this.newRecipientIdTarget.value = recipient.id
      this.newRecipientFormTarget.requestSubmit()
      this.newRecipientIdTarget.value = ""
    }

    this.clearSearch()
  }

  clearSearch() {
    var clearButton = this.autocompleteTarget.querySelector(".aa-ClearButton")
    if (clearButton) {
      clearButton.click()
    }
  }

  templateItem(item, html) {
    return html`<div class="aa-ItemWrapper">
      <div class="aa-ItemContent">
        <div class="aa-ItemContentBody">
          <span class="aa-ItemContentTitle">
            ${item.user.first_name} ${item.user.last_name}
          </span>
          <span class="aa-ItemContentDescription">
            ${item.user.email}
          </span>
        </div>
      </div>
    </div>`
  }

  findRecipientIdInput(id) {
    return this.recipientsTargets.find(input => input.value === id)
  }
}
