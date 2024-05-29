import Rails from '@rails/ujs'

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
      if (result) {
        const monthInput = document.getElementById('job_offer_estimate_monthly_salary_net')
        monthInput.value = result.estimate_monthly_salary_net

        const annualInput = document.getElementById('job_offer_estimate_annual_salary_gross')
        annualInput.value = result.estimate_annual_salary_gross
      }
    })
  })
}
