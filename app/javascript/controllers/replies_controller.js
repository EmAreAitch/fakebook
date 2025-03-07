import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comments"
export default class extends Controller {
  static targets = [ "replyButton", "listButton", "commentForm", "commentList"]  
  async getForm(e) {
    if (this.commentFormTarget.src != null && this.commentFormTarget.complete) {
      e.preventDefault()
    }
    this.commentFormTarget.classList.toggle("hidden")
    this.replyButtonTarget.textContent = this.commentFormTarget.classList.contains("hidden") ? "Reply" : "Cancel"

  }
  async getList(e) {
    if (this.commentListTarget.src != null && this.commentListTarget.complete) {
      e.preventDefault()
    }
    this.commentListTarget.classList.toggle("hidden")
    this.listButtonTarget.querySelector("span").textContent = this.commentListTarget.classList.contains("hidden") ? "Show" : "Hide"
  }
}
