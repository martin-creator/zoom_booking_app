require "http"
require "base64"

module Zoom
  class MeetingService
    ACCOUNT_ID = "F5SWzrhdT6S60Zd8DkY-aA"
    CLIENT_ID = "UfTsLmc8TXSXFg_p5NBJhg"
    CLIENT_SECRET = "oGiL5VBtVv8egGsGqgbXbk8u3h6SwARY"
    USER_ID = "aflSj9rETLSKD8FGU3Fu5g"

    def create_meeting(payload)
      begin
        access_token = get_access_token()
        puts access_token
        response = HTTP.post(
          "https://api.zoom.us/v2/users/#{USER_ID}/meetings",
          headers: { authorization: access_token },
          json: payload,
        )
      rescue Exception => e
        puts e.message
      end
    end

    def update_meeting(meeting_id, payload)
      begin
        access_token = get_access_token()
        response = HTTP.patch(
          "https://api.zoom.us/v2/meetings/#{meeting_id}",
          headers: { authorization: access_token },
          json: payload,
        )
      rescue Exception => e
        puts e.message
      end
    end

    private

    def get_access_token()
      url = "https://zoom.us/oauth/token"
      auth  = "Basic " + Base64.encode64("#{CLIENT_ID}:#{CLIENT_SECRET}").delete("\n")
      response = HTTP.post(
        "https://zoom.us/oauth/token",
        headers: { authorization: auth },
        params: { grant_type: "account_credentials",
                  account_id: ACCOUNT_ID },

      )

      data = response.parse
      access_token = "Bearer #{data["access_token"]}"
    end
  end
end
