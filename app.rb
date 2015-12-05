# encoding: utf-8

require "sinatra/base"
require "sinatra/flash"
require "mustache/sinatra"
require "sinatra-health-check"
require "sprockets"
require "sprockets-helpers"
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

  register Sinatra::Flash
  register Mustache::Sinatra

  require "#{base}/app/helpers"
  require "#{base}/app/views/layout"

  set :mustache, {
    :templates => "#{base}/app/templates",
    :views => "#{base}/app/views",
    :namespace => App
  }

  set :sprockets, Sprockets::Environment.new(root)
  set :assets_prefix, '/assets'
  set :assets_path, File.join(root, 'public', assets_prefix)
  set :digest_assets, false

  configure do
    sprockets.append_path "app/assets/stylesheets"
    sprockets.append_path "app/assets/javascripts"
  end

  Sprockets::Helpers.configure do |config|
    config.environment = sprockets
    config.prefix = assets_prefix
    config.digest = digest_assets
    config.public_path = public_folder
    config.debug = true if development?
  end

  before do
    @user = env['warden'].user
    @css = stylesheet_tag 'application'
    @js  = javascript_tag 'application'
    @path = request.path_info
    @rendered_flash = rendered_flash(flash)
    @checker = SinatraHealthCheck::Checker.new
  end

  helpers do
    include Sprockets::Helpers

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

  # To get user authentication to work.
  # Methods, Warden definitions, etc.
  require "#{base}/app/authentication"

end
