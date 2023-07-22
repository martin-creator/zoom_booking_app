require "base64"
require "http"

ACCOUNT_ID = "F5SWzrhdT6S60Zd8DkY-aA"
CLIENT_ID = "UfTsLmc8TXSXFg_p5NBJhg"
CLIENT_SECRET = "oGiL5VBtVv8egGsGqgbXbk8u3h6SwARY"
USER_ID = "aflSj9rETLSKD8FGU3Fu5g"



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

p "Access token: " + access_token
#p access_token

# Get users list
response = HTTP.get("https://api.zoom.us/v2/users", 
headers:{
    authorization: access_token
})

p "Users list: \n \n" 
p response.parse
# p response.parse

# Create a meeting

# response = HTTP.post(
#     "https://api.zoom.us/v2/users/aflSj9rETLSKD8FGU3Fu5g/meetings",
#     headers: { authorization: access_token },
#     json: {
#         topic: "Ruby meeting",
#         type: 2,
#         start_time: "2021-09-30T12:00:00Z",
#         duration: 60,
#         timezone: "Asia/Kolkata",
#     }
# )

# p response.parse

# Update a meeting

# response = HTTP.patch(
#     "https://api.zoom.us/v2/meetings/74033598680",
#     headers: { authorization: access_token },
#     json: {
#         topic: "Ruby meeting updated",
#         start_time: "2021-09-30T12:00:00Z",
#     }
# )

# p response.parse
