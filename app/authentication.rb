class App

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

  use Warden::Manager do |config|
    config.serialize_into_session{ |user| user.id }
    config.serialize_from_session{ |id| User.first(id: id) }
    config.scope_defaults :default,
      strategies: [:password],
      action: '/unauthenticated'
    config.failure_app = self
  end

  Warden::Manager.before_failure do |env, opts|
    env['REQUEST_METHOD'] = 'POST'
  end

end # close App

Warden::Strategies.add(:password) do

  def valid?
    params["username"] && params["password"]
  end

  def authenticate!
    user = User.first(username: params["username"])

    if user.nil?
      throw(:warden, message: "The username you entered does not exist.")
    elsif user.authenticate(params["password"])
      success!(user)
    else
      throw(:warden, message: "The username and password combination is incorrect.")
    end
  end
end
