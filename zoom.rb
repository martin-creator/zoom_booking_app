require "base64"
require "http"



auth  = "Basic " + Base64.encode64("#{CLIENT_ID}:#{CLIENT_SECRET}").delete("\n")

# p auth

# Get access token

response = HTTP.post(
    "https://zoom.us/oauth/token",
    headers: { authorization: auth },
    params: { grant_type: "account_credentials",
    account_id: ACCOUNT_ID, },

)

data = response.parse

access_token = "Bearer #{data["access_token"]}"

p access_token