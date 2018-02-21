require "rest-client"

class App

  def get_access_token_from_GitHub(session_code)
    result = RestClient.post('https://github.com/login/oauth/access_token',
                            {:client_id => ENV['GITHUB_CLIENT_ID'],
                             :client_secret => ENV['GITHUB_CLIENT_SECRET'],
                             :code => session_code},
                             :accept => :json)
    JSON.parse(result)['access_token']
  end

  def establish_user
    # puts "#{request.path_info}\nThe access_token is: #{session[:access_token]}\nThe user_id is: #{session[:user_id]}"
    if session[:user_id].nil?
      # No logged in user
      if session[:access_token].nil?
        # No token so just punt.
        nil
      else
        # Token so go get info from GitHub
        access_token = session[:access_token]
        begin
          auth_result = RestClient.get('https://api.github.com/user',
                                       {:params => {:access_token => access_token},
                                        :accept => :json})
        rescue => e
          # request didn't succeed because the token was revoked so we
          # invalidate the token stored in the session and render the
          # index page so that the user can start the OAuth flow again
          puts e.message
          session[:access_token] = nil
          redirect '/'
        end
        auth_result = JSON.parse(auth_result)
        user = User.where(username: auth_result['login']).first
        if user.nil? || user.enabled == false
          session[:access_token] = nil
          flash[:error] = "You are not allowed to use this application. Let Moacir know if you think this is in error."
          redirect "/login"
        else
          session[:user_id] = user.id
          user
        end
      end
    else
      # return the user
      User[session[:user_id]]
    end
  end

  def protected_page
    unless @user
      flash[:error] = "Must be logged in."
      redirect "/"
    end
  end

  def permitted_page(object)
    if object.class == Book
      if object.users.include?(@user)
        edit_code = true
      end
    else
      if object.user == @user
        edit_code = true
      end
    end
    if !@user.nil? && @user.admin?
      edit_code = true
    end
    unless edit_code
      flash[:error] = "Not allowed to add or edit this data."
      redirect "/"
    end
  end

  def admin_only_page
    unless @user.admin?
      flash[:error] = "Not allowed to visit admin-only pages."
      redirect "/"
    end
  end

end
