import { Controller } from "@hotwired/stimulus";

ZoomMtg.setZoomJSLib('https://source.zoom.us/2.14.0/lib', '/av')

ZoomMtg.preLoadWasm()
ZoomMtg.prepareWebSDK()

var SDK_KEY = '<%= Figaro.env.client_id %>'
var leaveUrl = 'http://localhost:3000/dashboard'

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
      .then((data) => { 
        console.log(data)
        this.joinMeeting(data.signature)
      })
      .catch((error) => {
        console.error(error);
      });
  }

  joinMeeting(signature) {
    ZoomMtg.init({
      leaveUrl: leaveUrl,
      success: (success) => {
        console.log(success)
        ZoomMtg.join({
          signature: signature,
          sdkKey: SDK_KEY,
          meetingNumber: this.meetingNumberValue,
          passWord: this.meetingPasswordValue,
          userName: this.userNameValue,
          success: (success) => {
            console.log(success)
          },
          error: (error) => {
            console.log(error)
          },
        })
      },
      error: (error) => {
        console.log(error)
      }
    })

  }

    
}
