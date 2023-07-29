import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="zoom"
export default class extends Controller {
  static values = {
    meetingNumber: Number,
    meetingPassword: String,
    userName: String,
    csrfToken: String,
  }
  connect() {
    console.log(this.meetingNumberValue)
    console.log(this.meetingPasswordValue)
    console.log(this.userNameValue)
    console.log(this.csrfTokenValue)
  }
}
