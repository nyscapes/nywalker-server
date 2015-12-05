class App

  get '/login' do
    @page_title = "Login"
    mustache :login
  end

  post '/login' do
    env['warden'].authenticate!

    if session[:return_to].nil?
      flash[:success] = "Successfully logged in."
      redirect '/'
    else
      redirect session[:return_to]
    end
  end

  post '/unauthenticated' do
    flash[:error] = env['warden.options'][:message]
    redirect '/login'
  end

  get '/logout' do
    env['warden'].raw_session.inspect
    env['warden'].logout
    flash[:success] = "Successfuly logged out"
    redirect '/'
  end

  get '/forgotten' do
    "Contact Moacir to reinitialize your user data"
  end


end
