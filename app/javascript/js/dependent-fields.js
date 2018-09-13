document.addEventListener("DOMContentLoaded", function() {
  let role_select = document.getElementById('administrator_role')
  if (role_select !== null) {
    role_select.addEventListener('change', triggerRoleChange, false)
  }
})

function triggerRoleChange() {
  let employer_select = document.getElementById('administrator_employer_id')
  if (employer_select !== null) {
    let value = this.options[this.selectedIndex].value
    employer_select.disabled = value !== 'employer'
  }
}

document.addEventListener("DOMContentLoaded", function() {
  let type_contract = document.getElementById('job_offer_contract_type_id')
  if (type_contract !== null) {
    type_contract.addEventListener('change', triggerTypeContractChange, false)
    triggerTypeContractChange()
  }
})

function triggerTypeContractChange() {
  let duration_contract = document.getElementById('job_offer_duration_contract')
  let type_contract = document.getElementById('job_offer_contract_type_id')
  let duration_contract_goup = document.getElementsByClassName('job_offer_duration_contract').item(0)
  if (duration_contract !== null) {
    let value = type_contract.options[type_contract.selectedIndex].text
    duration_contract_goup.hidden = value !== 'CDD'
    duration_contract.value = (value !== 'CDD')?"nop":"";
  }
}
