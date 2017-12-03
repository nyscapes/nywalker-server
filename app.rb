# encoding: utf-8

require "sinatra/base"
require "sinatra/flash"
require "mustache/sinatra"
require "sinatra-health-check"
require "sprockets"
require "sprockets-helpers"
require "warden"
require "googlebooks"
require "pony"
require "csv"
require "time"
require "stringex"
require "georuby"
require "geo_ruby/ewk" # lest the DB dump a 'uninitialized constant GeoRuby::SimpleFeatures::Geometry::HexEWKBParser' error.
require "active_support" # for the slug.
require "active_support/inflector"
require "active_support/core_ext/array/conversions"

require "descriptive_statistics"
require "redis"

require_relative "./model"

class App < Sinatra::Base
 
  use Rack::Session::Cookie, # use this instead of "enable :sessions"
    secret: ENV['COOKIE']
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

  set :redis, Redis.new
  set :nicknames_list, Proc.new { Nickname.all.map{ |n| { string: n.list_string, instance_count: n.instance_count } } }

  before do
    @user = env['warden'].user
    @css = stylesheet_tag 'application'
    @js  = javascript_tag 'application'
    @path = request.path_info
    @rendered_flash = rendered_flash(flash)
    @checker = SinatraHealthCheck::Checker.new
    @app_name = app_name
    @base_url = base_url
  end

  helpers do
    include Sprockets::Helpers

    def save_object(object, path, update = nil)
      message = "#{object.class} successfully updated!"
      update.nil? ? message.gsub!(/updated!$/, "saved!") : message
      begin
        object.save
        if object.class == Instance 
          redis.set "user-#{user.username}-last-instance", object.id
        end
        flash[:success] = message
        redirect path
      rescue Sequel::ValidationFailed => @e
        dm_error_and_redirect(object, path)
      rescue StandardError => @e
        mustache :error
      end
    end

    def dm_error_and_redirect(object, path, error = "")
      error = object.errors.map{ |key, value| "#{key} #{value.map{ |v| v }.join(',')}" }.to_sentence if error == ""
      flash[:error] = "Error: #{error}"
      redirect path
    end

    # def slugify(string)
    #   string = string.parameterize.underscore
    # end

    def book
      @book ||= Book[slug: params[:book_slug]] || halt(404)
    end

    def place
      @place ||= Place[slug: params[:place_slug]] || halt(404)
    end

    def instance
      @instance ||= Instance[params[:instance_id]] || halt(404)
    end

    def this_user
      @this_user ||= User[username: params[:user_username]] || halt(404)
    end

    def user
      @user ||= env['warden'].user
    end

    def redis
      settings.redis
    end

  end

  get "/" do
    @page_title = "Home"
    @json_file = "all_places"
    # @places = Place.real_places_with_instances("all")
    @places = Place.all_with_instances()
    mustache :index
  end

  post '/add_flag' do
    object = string_to_object(params[:flag_object_type])[params[:flag_object_id]]
    if object.update( flagged: true )
      flash_string = "The #{object.class.to_s.downcase} has been marked as flagged"
    end
    if Flag.create( comment: params[:flag_comment], object_type: object.class.to_s.downcase, object_id: object.id, added_on: Time.now, user: @user )
      flash_string += ", and the comment has been saved."
      body = flagged_msg_body_text(object, params[:flag_comment])
      mail("#{ENV['ADMIN_EMAIL_ADDRESS']}, #{@user.email}", "[NYWalker] Something got tagged", body)
    end
    flash[:success] = flash_string if flash_string
    redirect back
  end

  get "/about" do
    @page_title = "About"
    mustache :about
  end

  get "/citing" do
    @page_title = "Citing"
    @books = Book.where(id: Instance.select(:book_id)).order(:title).all
    mustache :citing
  end
  
  get "/rules" do
    @page_title = "Rules"
    mustache :rules
  end
  
  get "/help" do
    @page_title = "Help"
    mustache :help
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
        string << "<div class='alert #{bootstrap_class_for type} alert-dismissable fade show' role='alert'>"
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

  def string_to_object(string)
    case string
    when "place" then Place
    when "instance" then Instance
    else raise "Somehow I could not tell what kind of object this is."
    end
  end

  def app_name
    if ENV['CANON_NAME'] 
      ENV['CANON_NAME'] 
    else
      "NYWalker"
    end
  end

  def base_url
    if ENV['BASE_URL']
      "#{request.env['rack.url_scheme']}://#{ENV['BASE_URL']}"
    else
      "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    end
  end

  def mail(to, subject, body)
    Pony.mail(
      to: to,
      from: ENV['EMAIL_FROM_ADDRESS'],
      via: :smtp,
      via_options: {
        user_name: ENV['SMTP_USERNAME'],
        password: ENV['SMTP_PASSWORD'],
        address: ENV['SMTP_SERVER'],
        port: '587', enable_starttls_auto: true,
        authentication: :plain, domain: 'localhost.localdomain'
      },
      subject: subject,
      body: body
    )
    puts "Email sent to #{to} with a subject of #{subject}"
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

  def flagged_msg_body_text(object, comment)
    type = object.class.to_s.downcase
    if type == "place"
      url = "/places/#{object.slug}"
    elsif type == "instance"
      url = "/books/#{object.book.slug}/instances/#{object.id}"
    else
      url = "No clear URL"
    end
    <<-EOF
    Admin,

    A #{type} was marked as flagged by #{@user.name}:

    http://nywalker.newyorkscapes.org#{url}

    with this comment:

    #{comment}

    Thanks,

    --A Robot
    EOF
  end

  # To get user authentication to work.
  # Methods, Warden definitions, etc.
  require "#{base}/app/authentication"

  # The Rake methods that are also accessible from here.
  require "#{base}/app/rake-methods"

end

class Redis

  def cache(params)
    key = params[:key] || raise(":key parameter is required!")
    expire = params[:expire] || nil
    recalculate = params[:recalculate] || nil
    timeout = params[:timeout] || nil
    default = params[:default] || nil

    if (value = get(key)).nil? || recalculate
      begin
        value = Timeout::timeout(timeout) { yield(self) }
      rescue Timeout::Error
        value = default
      end

      set(key, value)
      expire(key, expire) if expire
      value
    else
      value
    end
  end

end
