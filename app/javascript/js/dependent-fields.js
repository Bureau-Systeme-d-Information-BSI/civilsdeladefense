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
