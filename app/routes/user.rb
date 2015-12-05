class App

  # ALL

  get '/users' do
    @page_title = "All Users"
    @users = User.all
    mustache :users_show
  end

  # CREATE

  get '/users/new' do
    @page_title = "Add New User"
    admin_only_page
    mustache :user_new
  end

  post '/users/new' do
    admin_only_page
    new_user = User.new
    new_user.attributes = { name: params[:name], admin: params[:admin], email: params[:email], added_on: Time.now, password: params[:password] }
    if params[:username] =~ /\W/
      flash[:error] = "Only alphanumeric characters in the username, please."
      redirect '/users/new'
    else
      new_user.username = params[:username]
    end
    save_object(new_user, "/users/#{new_user.username}")
  end

  # READ

  get '/users/:user_username' do
    @page_title = this_user.name
    mustache :user_show
  end

  # UPDATE

  # DESTROY
  
end
