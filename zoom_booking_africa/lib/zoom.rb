require "http"
require "base64"

module Zoom
  class MeetingService
    ACCOUNT_ID = "F5SWzrhdT6S60Zd8DkY-aA"
    CLIENT_ID = "UfTsLmc8TXSXFg_p5NBJhg"
    CLIENT_SECRET = "oGiL5VBtVv8egGsGqgbXbk8u3h6SwARY"
    USER_ID = "aflSj9rETLSKD8FGU3Fu5g"

    def create_meeting(payload)
    end

    def update_meeting(meeting_id, payload)
    end

    private
    
    def get_access_token()
      url = "https://zoom.us/oauth/token"
      auth = Base64.strict_encode64("#{CLIENT_ID}:#{CLIENT_SECRET}")
      response = HTTP.post(url, :form => {
        :grant_type => "account_credentials"
      }, :headers => {
        "Authorization" => "Basic #{auth}"
      })
      
      data = response.parse
      access_token = "Bearer #{data["access_token"]}"
    end

  end
end
