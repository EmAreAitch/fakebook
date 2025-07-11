import { Controller } from "@hotwired/stimulus"
import profiles from "api/ProfilesApi"
import follows from "api/FollowsApi"
import { FetchRequest } from '@rails/request.js'
import HotwireNotyf from "misc/hotwire_notyf"

export default class extends Controller {
  static targets = ["followStatusText", "profileUserRequestAction", "currentUserRequestAction"]
  static values = { profileUsername: String }

  async connect() {
    const response = await new FetchRequest("get", profiles.followStatus.path({ username: this.profileUsernameValue })).perform()
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

    let text = isAccepted(cur, prof) ? "You both follow each other" :
               isAccepted(cur) ? `You follow ${cur.followed_username}` :
               isAccepted(prof) ? `${prof.follower_username} follows you` : ''

    this.followStatusTextTarget.textContent = text
  }

  styledButton(text, action, color = "bg-accent-500") {
    const btn = document.createElement("button")
    btn.textContent = text
    btn.className = `${color} text-white px-4 py-2 rounded-md text-sm font-medium hover:opacity-90 transition`
    btn.addEventListener('click', action)
    return btn
  }

  updateCurrentUserRequestAction() {
    let button
    const isAccepted = this.currentUserRequest?.status == "accepted"

    if (!this.currentUserRequest) {
      button = this.styledButton("Follow", () => this.sendFollowRequest())
    } else {
      const text = isAccepted ? "Unfollow" : "Cancel Request"
      button = this.styledButton(text, () => this.removeFollowing(), "bg-gray-600")
    }

    this.currentUserRequestActionTarget.replaceChildren(button)
  }

  updateProfileUserRequestAction() {
    if (!this.profileUserRequest) return this.profileUserRequestActionTarget.replaceChildren()

    const buttons = []
    const isAccepted = this.profileUserRequest.status == "accepted"

    if (isAccepted) {
      buttons.push(this.styledButton("Remove", () => this.removeFollower(), "bg-red-600"))
    } else {
      buttons.push(this.styledButton("Accept", () => this.acceptFollowerRequest(), "bg-green-600"))
      buttons.push(this.styledButton("Reject", () => this.removeFollower(), "bg-red-600"))
    }

    this.profileUserRequestActionTarget.replaceChildren(...buttons)
  }

  async sendFollowRequest() {
    const response = await new FetchRequest('post', follows.create.path(), {
      body: { username: this.profileUsernameValue },
      responseKind: "json"
    }).perform()

    if (!response.ok) return HotwireNotyf.error(await response.text)

    this.currentUserRequest = await response.json
    this.updateUI()
    HotwireNotyf.success("Success")
  }

  async acceptFollowerRequest() {
    const response = await new FetchRequest('patch', follows.accept.path(this.profileUserRequest), { responseKind: "json" }).perform()
    if (!response.ok) return HotwireNotyf.error(await response.text)

    this.profileUserRequest.status = "accepted"
    this.updateUI()
    HotwireNotyf.success("Follow request accepted")
  }

  async destroyFollowing(id, type) {
    const response = await new FetchRequest('delete', follows.destroy.path({ id }), { responseKind: "json" }).perform()
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
