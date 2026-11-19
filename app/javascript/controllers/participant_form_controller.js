import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  connect() {
    console.log("ParticipantForm controller connected!")
  }

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML
    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {
    event.preventDefault()
    const item = event.target.closest(".nested-form-item")
    if (item) {
      item.remove()
    }
  }
}