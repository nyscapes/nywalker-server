# frozen_string_literal: true
class App

  get '/login' do
    @page_title = "Login"
    @client_id = ENV['GITHUB_CLIENT_ID']
    mustache :login
  end

  get '/callback' do
    # Taken from: https://developer.github.com/v3/guides/basics-of-authentication/
    session[:access_token] = get_access_token_from_GitHub params[:code]
    redirect '/'
  end

  get '/forgotten' do
    "Contact Moacir to reinitialize your user data"
  end


end
