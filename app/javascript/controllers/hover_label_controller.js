import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    hover: String
  }

  connect() {
    this.originalText = this.element.textContent.trim()
  }

  enter() {
    if (this.hasHoverValue && this.hoverValue) {
      this.element.textContent = this.hoverValue
    }
  }

  leave() {
    if (this.originalText) {
      this.element.textContent = this.originalText
    }
  }
}
