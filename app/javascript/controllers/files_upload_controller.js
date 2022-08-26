import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "files"]

  connect() {
    this.files = new DataTransfer()
    this.settingFiles = false
  }

  changed(e) {
    if (this.settingFiles) { return }

    this.storeFiles(e.target.files)
    this.showFiles(this.files.files)
  }

  add(e) {
    this.inputTarget.click()
    e.preventDefault()
  }

  remove(e) {
    this.files.items.remove(e.target.dataset.index)
    this.showFiles(this.files.files)
    e.preventDefault()
  }

  setFilesToUpload() {
    this.settingFiles = true
    this.inputTarget.files = this.files.files
    this.settingFiles = false
  }

  // private

  storeFiles(files) {
    for (var i = 0; i < files.length; i++) {
      this.files.items.add(files[i])
    }
  }

  showFiles(files) {
    this.filesTarget.innerHTML = ""

    for (var i = 0; i < files.length; i++) {
      let file = files[i]

      let li = document.createElement("li")
      li.appendChild(document.createTextNode(file.name + " "))

      let a = document.createElement("a")
      a.href = "#"
      a.dataset.action = "click->files-upload#remove"
      a.dataset.index = i
      a.appendChild(document.createTextNode("Retirer"));
      li.appendChild(a)

      this.filesTarget.appendChild(li)
    }
  }
}
