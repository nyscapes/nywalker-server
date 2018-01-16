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

  def establish_user_from_GitHub
    if session[:user_id].nil?
      if session[:access_token]
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
        # user = User.where(username: auth_result['login']).first
        # session[:github_username] = auth_result['login']
        user = User.where(username: auth_result['login']).first
        session[:user_id] = user.id
        user
      else
        nil
      end
    else
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
    unless @user.admin? || edit_code
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
