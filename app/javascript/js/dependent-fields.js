import 'mdn-polyfills/Element.prototype.closest'

function initRoleChange() {
  let role_select = document.getElementById('administrator_role')
  if (role_select !== null) {
    role_select.addEventListener('change', triggerRoleChange, false)
    var event = new Event('change')
    role_select.dispatchEvent(event)
  }
}

function triggerRoleChange() {
  let employer_select = document.getElementById('administrator_employer_id')
  let grand_employer_select = document.getElementById('administrator_grand_employer_id')
  if ((employer_select !== null) && (grand_employer_select !== null)) {
    let value = this.options[this.selectedIndex].value
    if ((value === 'employer') || (value === 'brh')) {
      employer_select.disabled = false
      employer_select.closest('.form-group').classList.remove('d-none')

      grand_employer_select.disabled = true
      grand_employer_select.closest('.form-group').classList.add('d-none')
    } else if (value === 'grand_employer') {
      employer_select.disabled = true
      employer_select.closest('.form-group').classList.add('d-none')

      grand_employer_select.disabled = false
      grand_employer_select.closest('.form-group').classList.remove('d-none')
    } else {
      employer_select.disabled = true
      employer_select.closest('.form-group').classList.add('d-none')

      grand_employer_select.disabled = true
      grand_employer_select.closest('.form-group').classList.add('d-none')
    }
  }
}

function initPageChange() {
  let onlyLinkCheckBox = document.getElementById('page_only_link')
  if (onlyLinkCheckBox !== null) {
    onlyLinkCheckBox.addEventListener('change', triggerPageChange, false)
    var event = new Event('change')
    onlyLinkCheckBox.dispatchEvent(event)
  }
}

function triggerPageChange() {
  let onlyLinkCheckBox = document.getElementById('page_only_link')
  if (onlyLinkCheckBox !== null) {
    let value = onlyLinkCheckBox.value
    if (onlyLinkCheckBox.checked == true) {
      ;[].forEach.call(document.querySelectorAll('.form-group.page_url'), function(el) {
        el.classList.remove('d-none')
      })
      ;[].forEach.call(document.querySelectorAll('.form-group.page_body, .form-group.page_og_title, .form-group.page_og_description'), function(el) {
        el.classList.add('d-none')
      })
    } else {
      ;[].forEach.call(document.querySelectorAll('.form-group.page_url'), function(el) {
        el.classList.add('d-none')
      })
      ;[].forEach.call(document.querySelectorAll('.form-group.page_body, .form-group.page_og_title, .form-group.page_og_description'), function(el) {
        el.classList.remove('d-none')
      })
    }
  }
}

function initJobApplicationFileTypeKindChange() {
  let select = document.getElementById('job_application_file_type_kind')
  if (select !== null) {
    select.addEventListener('change', triggerKindChange, false)
    var event = new Event('change')
    select.dispatchEvent(event)
  }
}

function triggerKindChange() {
  let content_input = document.getElementById('job_application_file_type_content')
  let value = this.options[this.selectedIndex].value
  if (value === 'template') {
    content_input.disabled = false
    content_input.closest('.form-group').classList.remove('d-none')
  } else {
    content_input.disabled = false
    content_input.closest('.form-group').classList.add('d-none')
  }
}

function initJobContractTypes() {
  let type_contract = document.getElementById('job_offer_contract_type_id')
  if (type_contract !== null) {
    type_contract.addEventListener('change', triggerTypeContractChange, false)
    triggerTypeContractChange(false)
  }
}

function triggerTypeContractChange(event_change = true) {
  let contract_duration = document.getElementById('job_offer_contract_duration_id')
  let type_contract = document.getElementById('job_offer_contract_type_id')
  let contract_duration_group = document.getElementsByClassName('job_offer_contract_duration').item(0)

  if (contract_duration !== null) {
    let value = type_contract.options[type_contract.selectedIndex].text

    // TODO: user duration field from type contract
    contract_duration_group.hidden = value !== 'CDD'
    if (event_change){
      if(value === 'CDD'){
        contract_duration.value = contract_duration.getAttribute("data-cdd-value")
        contract_duration.setAttribute("data-cdd-value", "")
      }
      else if(contract_duration.getAttribute("data-cdd-value") === "") {
        contract_duration.setAttribute("data-cdd-value", contract_duration.value)
        contract_duration.value = ""
      }
    } else {
      contract_duration.setAttribute("data-cdd-value", "")
    }
  }
}

export default function dependentFields() {
  initRoleChange()
  initJobApplicationFileTypeKindChange()
  initPageChange()
  initJobContractTypes()
}
