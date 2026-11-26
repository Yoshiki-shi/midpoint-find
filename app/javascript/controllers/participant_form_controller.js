import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template", "notice"]

  connect() {
    this.hideNotice()
    this.updateRemoveButtons()
  }

  add() {
    this.hideNotice()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, Date.now().toString())
    this.containerTarget.insertAdjacentHTML("beforeend", content)
    this.updateRemoveButtons()
  }

  remove(event) {
    this.hideNotice()
    const rows = this.containerTarget.querySelectorAll(".participant-row")
    if (rows.length <= 2) {
      this.updateRemoveButtons()
      return
    }

    const row = event.target.closest(".participant-row")
    if (row) {
      row.remove()
    }
    this.updateRemoveButtons()
  }

  addMember(event) {
    this.hideNotice()
    const name = event.currentTarget.dataset.name || ""
    const station = event.currentTarget.dataset.station || ""
    if (!station) return

    const rows = Array.from(this.containerTarget.querySelectorAll(".participant-row"))
    const duplicate = rows.some((row) => {
      const n = row.querySelector('[data-field="name"]')?.value.trim() || ""
      const s = row.querySelector('[data-field="station"]')?.value.trim() || ""
      return n === name && s === station
    })

    if (duplicate) {
      this.showNotice(`「${name || station}（${station}）」はすでに追加されています。`)
      return
    }

    const emptyRow = rows.find((row) => {
      const n = row.querySelector('[data-field="name"]')?.value.trim() || ""
      const s = row.querySelector('[data-field="station"]')?.value.trim() || ""
      return n === "" && s === ""
    })

    if (emptyRow) {
      const nameInput = emptyRow.querySelector('[data-field="name"]')
      const stationInput = emptyRow.querySelector('[data-field="station"]')
      if (nameInput) nameInput.value = name
      if (stationInput) stationInput.value = station
      this.updateRemoveButtons()
      return
    }

    this.add()
    const newRow = this.containerTarget.querySelector(".participant-row:last-child")
    if (newRow) {
      const nameInput = newRow.querySelector('[data-field="name"]')
      const stationInput = newRow.querySelector('[data-field="station"]')
      if (nameInput) nameInput.value = name
      if (stationInput) stationInput.value = station
    }
    this.updateRemoveButtons()
  }

  updateRemoveButtons() {
    const rows = this.containerTarget.querySelectorAll(".participant-row")
    const showRemove = rows.length > 2
    rows.forEach((row) => {
      const btn = row.querySelector('[data-action*="participant-form#remove"]')
      if (btn) {
        btn.style.display = showRemove ? "inline-block" : "none"
      }
    })
  }

  showNotice(message) {
    if (!this.hasNoticeTarget) return
    this.noticeTarget.textContent = message
    this.noticeTarget.style.display = "block"
  }

  hideNotice() {
    if (!this.hasNoticeTarget) return
    this.noticeTarget.textContent = ""
    this.noticeTarget.style.display = "none"
  }
}
