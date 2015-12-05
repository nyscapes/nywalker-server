# encoding: utf-8

require "sinatra/base"
require "sinatra/assetpack"
require "sinatra/flash"
require "mustache/sinatra"
require "sinatra-health-check"
require "warden"
require "googlebooks"
require "active_support" # for the slug.
require "active_support/inflector"
require "active_support/core_ext/array/conversions"

require_relative "./model"

class App < Sinatra::Base
  enable :sessions
  if Sinatra::Base.development?
    set :session_secret, "supersecret"
  end
  base = File.dirname(__FILE__)
  set :root, base

  register Sinatra::AssetPack
  register Sinatra::Flash
  register Mustache::Sinatra

  assets do
    serve "/js",    from: "app/js"
    serve "/css",   from: "app/css"

    css :app_css, [ "/css/*.css" ]
    js :app_js, [
      "/js/*.js",
      "/js/vendor/*.js"
    ]

  end

  require "#{base}/app/helpers"
  require "#{base}/app/views/layout"

  set :mustache, {
    :templates => "#{base}/app/templates",
    :views => "#{base}/app/views",
    :namespace => App
  }

  before do
    @user = env['warden'].user
    @css = css :app_css
    @js  = js  :app_js
    @path = request.path_info
    @rendered_flash = rendered_flash(flash)
    @checker = SinatraHealthCheck::Checker.new
  end

  helpers do

    def save_object(object, path)
      begin
        object.save
        flash[:success] = "#{object.class} successfully saved!"
        redirect path
      rescue DataMapper::SaveFailureError => e
        dm_error_and_redirect(object, path)
			rescue StandardError => e
				mustache :error_report, locals: { e: e }
      end
    end

    def dm_error_and_redirect(object, path, error = "")
      error = object.errors.values.join(', ') if error == ""
      flash[:error] = "Error: #{error}"
      redirect path
    end

    def slugify(string)
      string = string.parameterize.underscore
    end

    def book
      @book ||= Book.first(slug: params[:book_slug]) || halt(404)
    end

    def place
      @place ||= Place.first(slug: params[:place_slug]) || halt(404)
    end

    def instance
      @instance ||= Instance.first(id: params[:instance_id]) || halt(404)
    end

    def this_user
      @this_user ||= User.first(username: params[:user_username]) || halt(404)
    end

  end

  get "/" do
    @page_title = "Home"
    mustache :index
  end

  post '/report_error' do
    ref = env['HTTP_REFERER'] # could be request.referer or just "back"
    author = @user.name
    error = params[:error_report]
    "#{author} had to say about #{ref} this: #{error}"
  end

  get "/about" do
    @page_title = "About"
    mustache :about
  end
  
  # Other, CRUD routes.
  require "#{base}/app/routes/instance"
  require "#{base}/app/routes/book"
  require "#{base}/app/routes/place"
  require "#{base}/app/routes/user"
  require "#{base}/app/routes/authentication"


  def get_bbox(bbox)
    if bbox.class == Hash
      [bbox["east"], bbox["south"], bbox["north"], bbox["west"]].to_s
    end
  end

  def rendered_flash(flash)
    # doing just @flash = flash and then handling the flash rendering
    # inside mustache created a kind of persistence for the flash
    # messages, wholly ruining the point of the flash message in the
    # first place.
    string = ""
    if flash == {} || flash.nil?
      string
    else
      flash.each do |type, message|
        string << "<div class='alert #{bootstrap_class_for type} fade in'>"
        string << "<button class='close' data-dismiss='alert'>&times;</button>"
        unless message.nil?
          string << message
        end
        string << "</div>"
      end
      string
    end
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end

  get "/internal/health" do
    if @checker.healthy?
      "healthy"
    else
      status 503
      "unhealthy"
    end
  end

  get "/internal/status" do
    headers 'content-type' => 'application/json'
    @checker.status.to_json
  end

  not_found do
    if request.path =~ /\/$/
      redirect request.path.gsub(/\/$/, "")
    else
      status 404
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

end

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
