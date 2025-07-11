// app/javascript/controllers/post_toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["collapsible"]

  connect() {
    this.expanded = false    
  }

  toggle(event) {
    // Prevent toggle when text is selected
    const selection = window.getSelection()
    if (selection && selection.toString().trim().length > 0) return

    // Prevent toggle on double click (optional)
    if (event.detail > 1) return

    this.expanded = !this.expanded
    this.collapsibleTarget.classList.toggle("max-h-[18rem]", !this.expanded)    
    this.collapsibleTarget.title = this.expanded ? "Click to hide" : "Click to read more"
    console.log(this.collapsibleTarget.title)
    this.element.scrollIntoView({ behavior: "smooth", block: "start" })
  }
}
