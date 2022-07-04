import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["alert"]
  static values = { timeoutIn: Number }

  connect() {
    if (this.timeoutInValue) {
      this.startTimeoutTimer()
    }
  }

  disconnect() {
    this.stopTimeoutTimer()
  }

  // private

  alertTimeout() {
    this.alertTarget.classList.remove("d-none")
    this.stopTimeoutTimer()
  }

  startTimeoutTimer() {
    this.timer = setInterval(() => {
      this.alertTimeout()
    }, this.timeoutInValue - 300000) // Alert user when only 5 min of the session time is remaining
  }

  stopTimeoutTimer() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }
}
