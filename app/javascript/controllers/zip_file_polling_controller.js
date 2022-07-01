import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["waitingBody", "downloadLink"]
  static values = { url: String }

  connect() {
    this.startPolling()
  }

  disconnect() {
    this.stopPolling()
  }

  // private

  load() {
    fetch(this.urlValue, { headers: { accept: "application/json" } })
      .then(response => response.json())
      .then(data => {
        if (data.download_url) {
          this.stopPolling()
          this.downloadLinkTarget.href = data.download_url
          this.waitingBodyTarget.classList.add("d-none")
          this.downloadLinkTarget.classList.remove("d-none")
        }
      })
  }

  startPolling() {
    this.timer = setInterval(() => {
      this.load()
    }, 3000)
  }

  stopPolling() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }
}
