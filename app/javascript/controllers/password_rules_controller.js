import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "rules" ]

  connect() {
    this.rules = [
      {
        key: "length",
        message: "8 caractères minimum",
        positive: (value) => value.length >= 8
      },
      {
        key: "uppercase",
        message: "1 lettre majuscule minimum",
        positive: (value) => /[A-Z]/.test(value)
      },
      {
        key: "lowercase",
        message: "1 lettre minuscule minimum",
        positive: (value) => /[a-z]/.test(value)
      },
      {
        key: "number",
        message: "1 chiffre minimum",
        positive: (value) => /[0-9]/.test(value)
      },
      {
        key: "special",
        message: "1 caractère spécial minimum",
        positive: (value) => /[^A-Za-z0-9]/.test(value)
      }
    ]
  }
  
  check(e) {
    this.rules.forEach(rule => {
      this.setRuleStatus(rule, rule.positive(e.target.value))
    })
  }

  // private

  setRuleStatus(rule, valid) {
    const element = this.rulesTarget.querySelector(`[data-rule="${rule.key}"]`)
    if (valid) {
      element.classList.remove("invalid-rule")
      element.classList.add("valid-rule")
    } else { 
      element.classList.remove("valid-rule")
      element.classList.add("invalid-rule")
    }
    element.textContent = `${valid ? "✅" : "❌"} ${rule.message}`
  }
}
