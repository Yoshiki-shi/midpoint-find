import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String, title: String }

  copy(event) {
    event.preventDefault()
    const button = event.currentTarget
    navigator.clipboard.writeText(this.urlValue).then(() => {
      const originalText = button.textContent
      button.textContent = "✅ 共有用URLをコピーしました！"
      setTimeout(() => {
        button.textContent = originalText
      }, 2500)
    })
  }

  shareLine(event) {
    event.preventDefault()
    const title = this.hasTitleValue && this.titleValue ? this.titleValue : "集合場所のご案内"
    const text = `${title}\n中間駅とおすすめのお店候補はこちら👇\n${this.urlValue}`
    const lineUrl = `https://line.me/R/msg/text/?${encodeURIComponent(text)}`
    window.open(lineUrl, "_blank", "noopener,noreferrer")
  }
}
