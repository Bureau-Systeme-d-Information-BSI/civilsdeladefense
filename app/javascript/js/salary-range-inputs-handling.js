const Rails = require('rails-ujs')

export default function salaryRangeInputsHandling() {
  var reactiveElements = ['job_offer_professional_category_id', 'job_offer_experience_level_id', 'job_offer_sector_id']
  var reactiveElementsSelector = reactiveElements.map(item => `#${item}`).join(', ')
  ;[].forEach.call(document.querySelectorAll(reactiveElementsSelector), function(el) {
    el.addEventListener("ajax:before", function(event) {
      let form = event.currentTarget
      let dataStr = reactiveElements.filter(item => item.id !== form.id).map(item => {
        var element = document.getElementById(item)
        return Rails.serializeElement(element)
      }).join('&')
      form.setAttribute('data-params', dataStr)
    })
    el.addEventListener("ajax:success", function(event) {
      let detail = event.detail
      let data = detail[0]
      let result = data[0]
      let element = document.getElementById('job_offer_estimate_monthly_salary_net')
      if (result) {
        var estimateMonthlySalaryNet = result.estimate_monthly_salary_net
        if ((!element.value) || (!element.defaultValue)) {
          element.value = estimateMonthlySalaryNet
        }
        let elementHint = document.querySelector('.estimate_monthly_salary_net_reference')
        elementHint.innerHTML = estimateMonthlySalaryNet
      }
      element = document.getElementById('job_offer_estimate_annual_salary_gross')
      if (result) {
        var estimateAnnualSalaryGross = result.estimate_annual_salary_gross
        if ((!element.value) || (!element.defaultValue)) {
          element.value = estimateAnnualSalaryGross
        }
        let elementHint = document.querySelector('.estimate_annual_salary_gross_reference')
        elementHint.innerHTML = estimateAnnualSalaryGross
      }
    })
  })
}
