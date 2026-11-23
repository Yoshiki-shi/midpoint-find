import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  addMember(event) {
    const name = event.currentTarget.dataset.name || ""
    const station = event.currentTarget.dataset.station || ""
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
    this.appendRow()
  }

  remove(event) {
    const rows = this.containerTarget.querySelectorAll(".participant-row")
    if (rows.length <= 2) return
    const row = event.currentTarget.closest(".participant-row")
    if (row) row.remove()
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