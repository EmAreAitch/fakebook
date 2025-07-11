import { Controller } from "@hotwired/stimulus";
import HotwireNotyf from "misc/hotwire_notyf";

export default class extends Controller {
  static targets = ["interest", "tagTemplate", "botInterestsContainer"];

  addTag() {
    if (this.interestTargets.length >= 7) {
      HotwireNotyf.error("You can only add up to 7 tags.");
      return;
    }

    const template = this.tagTemplateTarget.content.cloneNode(true);
    const input = template.firstElementChild.firstElementChild
    input.name = input.name.replace("index",this.interestTargets.length)
    input.id = input.id.replace("index",this.interestTargets.length)
    this.botInterestsContainerTarget.appendChild(template);    
  }

  removeTag(event) {
    if (this.interestTargets.length > 4) {      
      event.currentTarget.parentElement.remove();      
    } else {
      HotwireNotyf.error("Please enter at least 4 tags.");
    } 
  }
}
