require 'securerandom'

class App
  namespace '/api/v1' do

    # none of this makes sense. The user should already have an access token.
    # I can write ember wrapper to reproduce App#get_access_token_from_GitHub
    # and App#establish_user later. The important thing is that there's a saved
    # token in redis, and every post request should check for that.

    # post '/token' do
    #   if @data[:grant_type] == "password"
    #     user = User.where(username: @data[:username]).first
    #     if user.nil?
    #       status 400
    #       error_invalid
    #     elsif user.authenticate(@data[:password]) == user
    #       token = SecureRandom.urlsafe_base64
    #       redis.mset "#{user.username}_access_token", token
    #       status 200
    #       { access_token: token, account_id: user.id }.to_json
    #     else
    #       status 400
    #       error_invalid
    #     end
    #   else
    #     status 400
    #     { "error": "unsupported_grant_type" }.to_json
    #   end
    # end

    # post '/revoke' do
    #   status 200
    # end

  end
end
