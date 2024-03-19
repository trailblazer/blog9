require "trailblazer/developer"
require "trailblazer/developer/client"

json = Trailblazer::Developer::Client.import(id: 90, email: "apotonick@gmail.com", api_key: "d903da42-e307-4f7c-bdbb-df984338605b", host: "https://api.trailblazer.to",
  query: "?mode=experimental.v1&labels=Create user!%3Esignup_submitted?%3Efailure")

File.write("app/concepts/auth/json/auth.signup-with-password-0.1.json", json)


# json = Trailblazer::Developer::Client.import(id: 87, email: "apotonick@gmail.com", api_key: "d903da42-e307-4f7c-bdbb-df984338605b", host: "https://api.trailblazer.to",
#   query: "?mode=experimental.v1&labels=?Create!%3Ecreate_invalid!%3Efailure,?Update!%3Eupdate_invalid!%3Efailure,?Revise!%3Erevise_invalid!%3Efailure,SuggestChanges%3EGatewayNone-kisu6hw2%3Efailure")

# File.write("app/concepts/workflow/blog.post-9.5.json", json)
