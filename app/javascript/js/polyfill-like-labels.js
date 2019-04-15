export default function getLabelsForInputElement(element) {
  let labels
  let selector
  let id = element.id

  if (element.labels) {
    return element.labels
  }

  if (id) {
    selector = `label[for='${id}']`
    return [ document.querySelector(selector) ]
  }

  return labels
}
