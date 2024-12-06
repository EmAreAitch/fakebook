import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from '@rails/request.js'
import { Notyf } from 'notyf'

// Connects to data-controller="like"
export default class extends Controller {
  static targets = [ "button" ]  
  static values = {
    url: String,
    likedText: String
  }  

  initialize() {
    this.notyf = new Notyf()
  }

  async toggleLike() {    
    const method = this.likeStatus ? "delete" : "post"    
    this.toggleState()
    this.buttonTarget.disabled = true
    const request = new FetchRequest(method, this.urlValue)
    const response = await request.perform()    
    if (!response.ok) {      
      this.notyf.error(await response.text)
      this.toggleState()
    }
    this.buttonTarget.disabled = false
  }

  buttonTargetConnected(element) {    
    const [text, count] = this.likedTextValue.split(" ")  
    this.likeStatus = (text == "Like" ? false : true)
    this.count = parseInt(count)    
    this.updateText()    
  }

  toggleState() {
    this.likeStatus = !this.likeStatus    
    this.count += this.likeStatus ? 1 : -1
    this.updateText()
  }

  updateText() {
    const text = this.likeStatus ? "Unlike" : "Like"
    this.buttonTarget.textContent = `${text} ${this.count}`
  }
}
