import { Controller } from "@hotwired/stimulus"
import {Notyf} from 'notyf'
// Connects to data-controller="flash"
export default class extends Controller {
  static values = { type: String }

  initialize() {
    this.notyf = new Notyf()
  }
  connect() {    
    this.notyf[this.typeValue](this.element.textContent)
  }
}
