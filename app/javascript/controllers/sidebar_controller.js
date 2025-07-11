// app/javascript/controllers/toggle_sidebar_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {  
  connect() {        
    this.sidebar = document.getElementById("sidebar");    
  }

  toggle() {
    this.sidebar.classList.toggle("-translate-x-full")
  }

  show() {
    this.sidebar.classList.remove("-translate-x-full")
  }

  hide() {
    this.sidebar.classList.add("-translate-x-full")
  }
}
