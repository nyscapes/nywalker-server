# frozen_string_literal: true
require "net/http"
require "uri"
require "jwt"

class NYWalkerServer
  namespace '/api/v1' do

  end
end

# This class manages the JSON web token provided by Auth0. The code is based on
# the code provided by Auth0 at https://auth0.com/docs/quickstart/backend/ruby.

class JsonWebToken

  # Verifies the incoming access_token token from the Authorization header of
  # the request.
  # Params:
  # +token+:: The access token.
  def self.verify(token)
    JWT.decode(token, nil,
               true, # Verify signature
               iss: 'https://nywalker.auth0.com/',
               verify_iss: true,
               # auth0_api_audience is the identifier for the API set up in the Auth0 dashboard
               aud: 'http://nywalker.newyorkscapes.org',
               verify_aud: true) do |header|
      jwks_hash[header['kid']]
    end
  end

  # Creates a hash from the Authorization header of
  # the request.
  def self.jwks_hash
    jwks_raw = Net::HTTP.get URI("https://nywalker.auth0.com/.well-known/jwks.json")
    jwks_keys = Array(JSON.parse(jwks_raw)['keys'])
    Hash[
      jwks_keys
      .map do |k|
        [
          k['kid'],
          OpenSSL::X509::Certificate.new(
            Base64.decode64(k['x5c'].first)
          ).public_key
        ]
      end
    ]
  end

end
