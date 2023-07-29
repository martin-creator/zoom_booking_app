import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="zoom"
export default class extends Controller {
  static values = {
    meetingNumber: Number,
    meetingPassword: String,
    userName: String,
    csrfToken: String,
  };

  connect() {
    this.startMeeting();
  }

  startMeeting() {
    // Generate Signature with meeting details
    fetch("http://localhost:3000/generate_signature", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.csrfTokenValue,
      },
      body: JSON.stringify({
        meetingNumber: this.meetingNumberValue,
      }),
    })
      .then((response) => { return response.json()})
      .then((data) => { console.log(data)})
      .catch((error) => {
        console.error(error);
      });
  }
}
