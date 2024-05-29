import { Controller } from "@hotwired/stimulus"

const INCORRECT_SUFFIXES = [
  "f/h", "f/H", "F/h",
  "h/f", "H/f", "h/F", "H/F",
  "fh", "FH", "Fh", "fH",
  "hf", "HF", "Hf", "hF"
]
const CORRECT_SUFFIX = "F/H"

export default class extends Controller {
  correctTitle(event) {
    const title = event.target.value
    if (this.endsWithIncorrectSuffix(title)) {
      event.target.value = this.replaceLastWithCorrectSuffix(title)
    } else if (!title.endsWith("F/H")) {
      event.target.value = title + " F/H"
    }
  }

  // private

  endsWithIncorrectSuffix(str) {
    return INCORRECT_SUFFIXES.some(suffix => str.endsWith(suffix))
  }

  replaceLastWithCorrectSuffix(str) {
    const foundSuffix = INCORRECT_SUFFIXES.find(suffix => str.endsWith(suffix))
    return this.replaceLast(str, foundSuffix)
  }

  replaceLast(str, search) {
    const indexOfLast = str.lastIndexOf(search)
    return str.substring(0, indexOfLast) + CORRECT_SUFFIX
  }
}