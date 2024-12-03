import { Controller } from "@hotwired/stimulus"
import * as WebAuthnJSON from "@github/webauthn-json"
import { FetchRequest } from "@rails/request.js"

export default class extends Controller {
  static targets = ["nickname"]
  static values = { callback: String }

  async create(event) {
    event.preventDefault()    
    const formData = new FormData(this.element)
    const request = new FetchRequest('post',this.element.action)
    const response = await request.perform()
    const _this = this
    if (response.ok) {
      const data = await response.json            
      WebAuthnJSON.create({ "publicKey": data }).then(async function(credential) {
        const request = new FetchRequest("post", _this.callbackValue + `?nickname=${_this.nicknameTarget.value}`, { body: JSON.stringify(credential)})
        await request.perform()
      }).catch(function(error) {
        console.log("something is wrong", error);
      });
    }        
  }

  error(event) {
    console.log("something is wrong", event);
  }
}