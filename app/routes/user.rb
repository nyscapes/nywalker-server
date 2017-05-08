class App

  # ALL

  get '/users' do
    protected_page
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
    new_user.set( name: params[:name], admin: params[:admin], email: params[:email], added_on: Time.now, password: params[:password] )
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
    protected_page
    @page_title = this_user.name
    mustache :user_show
  end

  # UPDATE

  post '/users/:user_username/change-password' do
    this_user
    if params[:new_password1] == params[:new_password2]
      unless @user.admin?
        unless @this_user.authenticate(params[:current_password])
          flash[:error] = "The current password is incorrect."
          redirect back
        end
      end
      if @this_user.update( password: params[:new_password1] )
        body = password_change_body_text(@this_user.name, "http://nywalker.newyorkscapes.org/users/#{@this_user.username}")
        mail(@this_user.email, "[NYWalker] Password Changed", body)
        flash[:success] = "The password has been changed."
      else
        flash[:error] = "Some unexpected error occurred. Please try again."
      end
    else
      flash[:error] = "The new passwords do not match."
    end
   redirect back
  end

  def password_change_body_text(name, user_profile_url)
    <<-EOF
    Dear #{name},

    Your password for NYWalker has been changed.

    You can visit your profile page here:

    #{user_profile_url}
    EOF
  end

  # DESTROY
  
end
