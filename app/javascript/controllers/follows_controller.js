import { Controller } from "@hotwired/stimulus"
import profiles from "api/ProfilesApi"
import follows from "api/FollowsApi"
import { FetchRequest } from '@rails/request.js'
import HotwireNotyf from "misc/hotwire_notyf"

export default class extends Controller {
  static targets = ["followStatusText", "profileUserRequestAction", "currentUserRequestAction"]
  static values = { profileUsername: String }

  async connect() {    
    const response = await new FetchRequest("get", profiles.followStatus.path({username: this.profileUsernameValue})).perform()     
    if (!response.ok) return HotwireNotyf.error("Failed to get user follow status.")
      
    const followStatus = await response.json          
    this.currentUserRequest = followStatus.find(i => i.followed_username == this.profileUsernameValue)
    this.profileUserRequest = followStatus.find(i => i.follower_username == this.profileUsernameValue)
    this.updateUI()
  }

  updateUI() {
    this.updateStatusText()
    this.updateCurrentUserRequestAction()
    this.updateProfileUserRequestAction()
  }

  updateStatusText() {
    const isAccepted = (...requests) => requests.every(i => i?.status == "accepted")
    const { currentUserRequest: cur, profileUserRequest: prof } = this
    
    let text = isAccepted(cur, prof) ? "You both are following each other" :
               isAccepted(cur) ? `You follow ${cur.followed_username}` :
               isAccepted(prof) ? `${prof.follower_username} follows you` : ''
    
    this.followStatusTextTarget.textContent = text
  }

  updateCurrentUserRequestAction() {
    const button = document.createElement("button")
    const isAccepted = this.currentUserRequest?.status == "accepted"
    
    if (!this.currentUserRequest) {
      button.textContent = "Follow"
      button.addEventListener('click', () => this.sendFollowRequest())
    } else {
      button.textContent = isAccepted ? "Unfollow" : "Destroy Request"
      button.addEventListener('click', () => this.removeFollowing())
    }
    
    this.currentUserRequestActionTarget.replaceChildren(button)
  }

  updateProfileUserRequestAction() {
    if (!this.profileUserRequest) return this.profileUserRequestActionTarget.replaceChildren()
    
    const buttons = [document.createElement("button")]
    const isAccepted = this.profileUserRequest.status == "accepted"
    
    if (isAccepted) {
      buttons[0].textContent = "Remove"
      buttons[0].addEventListener('click', () => this.removeFollower())
    } else {
      buttons[0].textContent = "Accept"
      buttons[0].addEventListener('click', () => this.acceptFollowerRequest())
      buttons.push(document.createElement("button"))
      buttons[1].textContent = "Reject"
      buttons[1].addEventListener('click', () => this.removeFollower())
    }
    
    this.profileUserRequestActionTarget.replaceChildren(...buttons)
  }

  async sendFollowRequest() {
    const response = await new FetchRequest('post', follows.create.path(), {
      body: {username: this.profileUsernameValue},
      responseKind: "json"
    }).perform()
    
    if (!response.ok) return HotwireNotyf.error(await response.text)
    
    this.currentUserRequest = await response.json
    this.updateUI()
    HotwireNotyf.success("Request sent")
  }

  async acceptFollowerRequest() {    
    const response = await new FetchRequest('patch', follows.accept.path(this.profileUserRequest),{responseKind: "json"}).perform()
    if (!response.ok) return HotwireNotyf.error(await response.text)
    
    this.profileUserRequest.status = "accepted"
    this.updateUI()
    HotwireNotyf.success("Success")
  }

  async destroyFollowing(id, type) {
    const response = await new FetchRequest('delete', follows.destroy.path({id}), {responseKind: "json"}).perform()
    if (!response.ok) return HotwireNotyf.error("Something went wrong")
    
    this[type] = undefined
    this.updateUI()
    HotwireNotyf.success("Success")
  }

  removeFollowing() {
    this.destroyFollowing(this.currentUserRequest.id, 'currentUserRequest')
  }

  removeFollower() {
    this.destroyFollowing(this.profileUserRequest.id, 'profileUserRequest')
  }
}