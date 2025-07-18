import { Controller } from "@hotwired/stimulus"
import * as WebAuthnJSON from "@github/webauthn-json"
import { FetchRequest } from "@rails/request.js"
import HotwireNotyf from "misc/hotwire_notyf"
export default class extends Controller {
  static values = { callback: String }

  async auth(event) {
    event.preventDefault()       
    const formData = new FormData(this.element)
    const request = new FetchRequest('post',this.element.action)
    const response = await request.perform()
    const _this = this

    if (response.ok) {
      const data = await response.json    
      WebAuthnJSON.get({ "publicKey": data }).then(async function(credential) {
      const request = new FetchRequest("post", _this.callbackValue, { body: JSON.stringify(credential) })
      const response = await request.perform()

      if (response.ok) {
        const data = await response.json
        window.Turbo.visit(data.redirect, {action: 'replace'})
      } else {
        HotwireNotyf.error(response.text);
      }
      }).catch(function(error) {
        HotwireNotyf.error(error.message);
      });
    }
  }  
}
