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
# require "georuby"
# require "geo_ruby/ewk"

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
    # serve "/img",   from: "app/img"

    css :app_css, [ "/css/*.css" ]
    js :app_js, [
      "/js/*.js",
      "/js/vendor/*.js"
    ]

    # prebuild true

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

  end

  get "/" do
    @page_title = "Home"
    mustache :index
  end

  get "/places/new" do
    protected_page
    @page_title = "Add New Place"
    mustache :place_new
  end

  post "/places/add" do
    protected_page
    new_place = Place.new
    new_place.attributes = { name: params[:name], lat: params[:lat], lon: params[:lon], source: params[:source], confidence: params[:confidence], user: @user, added_on: Time.now, what3word: params[:w3w] }
    if new_place.source == "GeoNames"
      new_place.bounding_box_string = params[:bbox]
      new_place.geonameid = params[:geonameid]
    end
    if new_place.lat == "" && new_place.lon == ""
      new_place.lat = nil
      new_place.lon = nil
      new_place.confidence = 0
    end
    new_place.slug = slugify new_place.name
    # new_place.geom = GeoRuby::SimpleFeatures::Point.from_x_y(new_place.lon, new_place.lat, 4326)
    # create_bounding_box(place) # because this doesn't seem to work.
    begin
      new_place.save
      Nickname.first_or_create(name: new_place.name, place: new_place)
      if params[:form_source] == "modal"
        @place = new_place
        mustache :modal_place_saved, { layout: :naked }
      else
        flash[:success] = "#{new_place.name} successfully saved!"
        redirect "/places/#{new_place.slug}"
      end
    rescue DataMapper::SaveFailureError => e
      mustache :error_report, locals: { e: e, validation: new_place.errors.values.join(', ') }
    rescue StandardError => e
      mustache :error_report, locals: { e: e }
    end
  end

  post "/search-place" do
    protected_page
    geonames_username = "moacir" # This should be changed
    @search_term = params[:search] # needed for mustache.
    query = "http://api.geonames.org/searchJSON?username=#{geonames_username}&style=full&q=#{@search_term}"
    query << "&countryBias=US" if params[:us_bias] == "on"
    query << "&south=40.48&west=-74.27&north=40.9&east=-73.72" if params[:nyc_limit] == "on"
    results = JSON.parse(HTTParty.get(query).body)["geonames"]
    if results.length == 0
      @results = nil
    else
      @results = results[0..4].map{|r| {name: r["toponymName"], lat: r["lat"], lon: r["lng"], description: r["fcodeName"], geonameid: r["geonameId"], bbox: get_bbox(r["bbox"]) } }
    end
    mustache :search_results, { layout: :naked }
  end

  get "/books/new" do
    protected_page
    @page_title = "Add New Book"
    mustache :book_new
  end

  post "/books/new" do
    protected_page
    @page_title = "Adding ISBN: #{params[:isbn]}"
    result = GoogleBooks.search("isbn:#{params[:isbn]}").first
    unless result.nil?
      @new_book = { author: result.authors,
                    title: result.title,
                    year: result.published_date[0..3],
                    last_page: result.page_count,
                    cover: result.image_link,
                    link: result.info_link }
    else
      # clumsy kludge for when GoogleBooks returns nothing
      @new_book = { author: "AUTHOR NOT FOUND",
                    title: "TITLE NOT FOUND",
                    year: "",
                    last_page: "",
                    cover: nil,
                    link: "" }
    end
    @isbn = params[:isbn] # sometimes google doesn't return one.
    mustache :book_new_post
  end

  post "/add-book" do
    protected_page
    @page_title = "Saving #{params[:title]}"
    saved_book = Book.new
    saved_book.attributes = { author: params[:author], title: params[:title], isbn: params[:readonlyISBN], cover: params[:cover], url: params[:link], year: params[:year], users: [@user], slug: slugify("#{params[:title][0..45]}_#{params[:year]}"), added_on: Time.now }
    save_object(saved_book, "/books/#{saved_book.slug}")
  end

  get "/books/:book_slug" do
    @page_title = "#{book.title}"
    @instances = Instance.all(book: book, order: [:page.asc, :sequence.asc]) # place.instances doesn't work?
    mustache :book_show
  end

  get "/books" do
    @page_title = "All Books"
    @books = Book.all
    mustache :books_show
  end

  get "/books/:book_slug/instances/new" do
    protected_page
    @page_title = "New Instance for #{book.title}"
    @last_instance = Instance.last(user: @user, book: book)
    @nicknames = Nickname.map{|n| "#{n.name} - {#{n.place.name}}"}
    mustache :instance_new
  end

  post "/books/:book_slug/instances/new" do
    protected_page
    @page_title = "Saving Instance for #{book.title}"
    instance = Instance.new
    instance.attributes = { page: params[:page], sequence: params[:sequence], text: params[:place_name_in_text], added_on: Time.now, user: @user, book: book }
    if params[:place].match(/{.*}$/)
      place = params[:place].match(/{.*}$/)[0].gsub(/{/, "").gsub(/}/, "")
    else
      dm_error_and_redirect(instance, request.path, "The place did not have a name coded inside {}s")
    end
    location = Place.first(name: place)
    if location.nil?
      dm_error_and_redirect(instance, request.path, "No such place found. Please add it below.")
    end
    instance.place = location
    Nickname.first_or_create(name: instance.text, place: location)
    save_object(instance, request.path)
  end

  get "/books/:book_slug/instances/:instance_id/edit" do
    protected_page
    @page_title = "Editing Instance #{instance.id} for #{book.title}"
    @nicknames = Nickname.map{|n| "#{n.name} - {#{n.place.name}}"}
    mustache :instance_edit
  end

  post "/books/:book_slug/instances/:instance_id/edit" do
    protected_page
    instance.attributes = { page: params[:page], sequence: params[:sequence], text: params[:place_name_in_text], modified_on: Time.now, user: @user, book: book }
    if params[:place].match(/{.*}$/) # We've likely modified the place.
      instance.place = params[:place].match(/{.*}$/)[0].gsub(/{/, "").gsub(/}/, "")
    end
    Nickname.first_or_create(name: instance.text, place: instance.place)
    save_object(instance, "/books/#{params[:book_slug]}/instances/new")
  end

  post "/books/:book_slug/instances/:instance_id/delete" do
    protected_page
    puts "Deleting Instance #{instance.id} for #{book.title}"
    page_instances = Instance.all(book: book, page: instance.page, :sequence.gt => instance.sequence)
    if instance.destroy
      page_instances.each do |instance|
        instance.update(sequence: instance.sequence - 1)
      end
      flash[:success] = "Deleted instance #{instance.id}, from page #{instance.page} marking #{instance.text}."
      redirect "/books/#{book.slug}"
    else
      flash[:error] = "Something went wrong."
      redirect "/books/#{book.slug}"
    end
  end

  get "/places" do
    @page_title = "All places"
    @places = Place.all
    mustache :places_show
  end

  get "/places/:place_slug" do
    @page_title = "#{place.name}"
    @books = Book.all(instances: Instance.all(place: place))
    mustache :place_show
  end

  post "/places/:place_slug/edit" do
    protected_page
    @page_title = "Editing #{place.name}"
    if place.update( name: params[:name], lat: params[:lat], lon: params[:lon], confidence: params[:confidence], source: params[:source], geonameid: params[:geonameid], bounding_box_string: params[:bounding_box_string], what3word: "" )
      flash[:success] = "#{place.name} has been updated"
      '<script>$("#editPlaceModal").modal("hide");window.location.reload();</script>'
    else
      flash[:error] = "Something went wrong."
      mustache :place_edit, { layout: :naked }
    end
  end

  get "/about" do
    @page_title = "About"
    mustache :about
  end

  def get_bbox(bbox)
    if bbox.class == Hash
      [bbox["east"], bbox["south"], bbox["north"], bbox["west"]].to_s
    end
  end

  def create_bounding_box(place)
    # This doesn't actually seem to build a useful polygon.
    place.bounding_box = BoundingBox.new
    if place.bounding_box_string =~ /^\[.*\]$/
      bbox = place.bounding_box_string.gsub(/^\[/, "").gsub(/\]$/, "").split(", ")
      # place.bounding_box.geom = GeoRuby::SimpleFeatures::Polygon.from_coordinates([
      #   [ bbox[0], bbox[1] ],
      #   [bbox[0], bbox[2]],
      #   [bbox[3], bbox[2]],
      #   [bbox[3], bbox[1]]
      # ], 4326)
    else
      # place.bounding_box.geom = nil
    end
    place.save
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

  get '/login' do
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
    puts "someone failed"
    # env['warden'].raw_session.inspect
    redirect '/login'
  end

  get '/logout' do
    env['warden'].raw_session.inspect
    env['warden'].logout
    flash[:success] = "Successfuly logged out"
    redirect '/'
  end

  get '/admin' do
    user = env['warden'].user
    "#{user.username} whoa!"
  end

  get '/forgotten' do
    "Contact Moacir to reinitialize your user data"
  end

  def protected_page
    unless @user
      flash[:error] = "Must be logged in."
      redirect "/"
    end
  end

  not_found do
    if request.path =~ /\/$/
      redirect request.path.gsub(/\/$/, "")
    else
      status 404
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
      puts "user nil!"
      throw(:warden, message: "The username you entered does not exist.")
    elsif user.authenticate(params["password"])
      success!(user)
    else
      puts "combination is wrong."
      throw(:warden, message: "The username and password combination is incorrect.")
    end
  end
end
