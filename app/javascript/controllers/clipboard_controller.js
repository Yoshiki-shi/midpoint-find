import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  copy(event) {
    event.preventDefault()
    const button = event.currentTarget
    navigator.clipboard.writeText(this.urlValue).then(() => {
      const originalText = button.textContent
      button.textContent = "✅ 共有URLをコピーしました！"
      setTimeout(() => {
        button.textContent = originalText
      }, 2500)
    })
  }
}
