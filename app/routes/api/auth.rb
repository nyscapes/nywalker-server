class App
  namespace '/api/v1' do

    post '/token' do
      if @data.nil? || @data.length == 0
        status 400
        { "error": "no_request_payload" }.to_json
      elsif @data[:grant_type] == "password"
        user = User.where(username: @data[:username]).first
        if user.nil?
          status 400
          error_invalid
        elsif user.authenticate(@data[:password]) == user
          status 200
          { "access_token": "secret!", "account_id": user.id }.to_json
        else
          status 400
          error_invalid
        end
      else
        status 400
        { "error": "unsupported_grant_type" }.to_json
      end
    end

    post '/revoke' do
      status 200
    end

  end
end
