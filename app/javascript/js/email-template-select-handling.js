export default function emailTemplateSelectHandling() {
  var node = document.getElementById('email_template_selector')
  if (node !== null) {
    node.addEventListener("ajax:success", function(event) {
      let detail = event.detail
      let emailTemplate = detail[0]
      if (emailTemplate) {
        let subjectNode = document.querySelector('[id$="email_subject"]')
        if (subjectNode !== null) {
          subjectNode.value = emailTemplate.subject
        }
        let bodyNode = document.querySelector('[id$="email_body"]')
        if (bodyNode !== null) {
          bodyNode.value = emailTemplate.body
        }
      }
    })
  }
}
