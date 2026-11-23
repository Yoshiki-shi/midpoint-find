import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template", "notice"]

  addMember(event) {
    const name = (event.currentTarget.dataset.name || "").trim()
    const station = (event.currentTarget.dataset.station || "").trim()

    if (this.isAlreadyAdded(name, station)) {
      this.showNotice(`${name || station} はすでに追加されています。`)
      return
    }

    this.clearNotice()
    const emptyRow = this.findEmptyRow()

    if (emptyRow) {
      const nameInput = emptyRow.querySelector("[data-field='name']")
      const stationInput = emptyRow.querySelector("[data-field='station']")
      if (nameInput && name) nameInput.value = name
      if (stationInput && station) stationInput.value = station
      return
    }

    const row = this.appendRow()
    if (!row) return
    const nameInput = row.querySelector("[data-field='name']")
    const stationInput = row.querySelector("[data-field='station']")
    if (nameInput && name) nameInput.value = name
    if (stationInput && station) stationInput.value = station
  }

  add() {
    this.clearNotice()
    this.appendRow()
  }

  remove(event) {
    const rows = this.containerTarget.querySelectorAll(".participant-row")
    const row = event.currentTarget.closest(".participant-row")

    if (rows.length <= 2) {
      if (row) {
        const nameInput = row.querySelector("[data-field='name']")
        const stationInput = row.querySelector("[data-field='station']")
        if (nameInput) nameInput.value = ""
        if (stationInput) stationInput.value = ""
      }
      this.showNotice("出発駅は最低2名分必要です（2行以下のため入力内容をクリアしました）。")
      return
    }

    this.clearNotice()
    if (row) row.remove()
  }

  isAlreadyAdded(name, station) {
    const rows = Array.from(this.containerTarget.querySelectorAll(".participant-row"))
    return rows.some((row) => {
      const rowName = (row.querySelector("[data-field='name']")?.value || "").trim()
      const rowStation = (row.querySelector("[data-field='station']")?.value || "").trim()
      if (name && station) {
        return rowName === name && rowStation === station
      }
      return Boolean(station && rowStation === station)
    })
  }

  showNotice(message) {
    if (!this.hasNoticeTarget) return
    this.noticeTarget.textContent = message
    this.noticeTarget.style.display = "block"
  }

  clearNotice() {
    if (!this.hasNoticeTarget) return
    this.noticeTarget.textContent = ""
    this.noticeTarget.style.display = "none"
  }

  findEmptyRow() {
    const rows = Array.from(this.containerTarget.querySelectorAll(".participant-row"))
    return rows.find((row) => {
      const stationInput = row.querySelector("[data-field='station']")
      return stationInput && stationInput.value.trim() === ""
    })
  }

  appendRow() {
    if (!this.hasTemplateTarget) return null
    const index = Date.now() + Math.floor(Math.random() * 1000)
    const html = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, index)
    this.containerTarget.insertAdjacentHTML("beforeend", html)
    const rows = this.containerTarget.querySelectorAll(".participant-row")
    return rows[rows.length - 1]
  }
}
