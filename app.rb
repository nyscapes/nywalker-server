require "sinatra/base"
require "sinatra/assetpack"
require "mustache/sinatra"
require "googlebooks"
require "active_support" # for the slug.
require "active_support/inflector"
require "active_support/core_ext/array/conversions"

require_relative "./model"

class App < Sinatra::Base
  base = File.dirname(__FILE__)
  set :root, base

  register Sinatra::AssetPack
  register Mustache::Sinatra

  assets do
    serve "/js",    from: "app/js"
    serve "/css",   from: "app/css"
    serve "/img",   from: "app/img"

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
    @user = User.first
    @css = css :app_css
    @js  = js  :app_js
    @path = request.path_info
  end

  helpers do

  end

  
  # Function allows both get / post.
  def self.get_or_post(path, opts={}, &block)
    get(path, opts, &block)
    post(path, opts, &block)
  end   

  get "/" do
    @page_title = "Home"
    mustache :index
  end

  get "/new-book" do
    @page_title = "Add New Book"
    mustache :new_book
  end

  get "/place/new" do
    @page_title = "Add New Place"
    mustache :place_new
  end

  post "/place/add" do
    place = Place.new
    place.attributes = { name: params[:name], lat: params[:lat], lon: params[:lon], source: params[:source], confidence: params[:confidence], geonameid: params[:geonameid], user: @user, added_on: Time.now, bounding_box_string: params[:bbox] }
    place.slug = place.name.parameterize.underscore
    place.geom = GeoRuby::SimpleFeatures::Point.from_x_y(place.lon, place.lat)
    # create_bounding_box(place) # because this doesn't seem to work.
    begin
      place.save
      redirect "/places/#{place.slug}"
    rescue DataMapper::SaveFailureError => e
      mustache :error_report, locals: { e: e, validation: place.errors.values.join(', ') }
    rescue StandardError => e
      mustache :error_report, locals: { e: e }
    end

  end

  post "/search-place" do
    geonames_username = "moacir" # This should be changed
    @search_term = params[:search] # needed for mustache.
    query = "http://api.geonames.org/searchJSON?username=#{geonames_username}&style=full&q=#{@search_term}"
    query = query + "&countryBias=US" if params[:us_bias] == "on"
    query = query + "&south=40.48&west=-74.27&north=40.9&east=-73.72" if params[:nyc_limit] == "on"
    results = JSON.parse(HTTParty.get(query).body)["geonames"]
    if results.length == 0
      @results = nil
    else
      @results = results[0..4].map{|r| {name: r["toponymName"], lat: r["lat"], lon: r["lng"], description: r["fcodeName"], geonameid: r["geonameId"], bbox: get_bbox(r["bbox"]) } }
    end
    mustache :search_results, { layout: :naked }
  end

  post "/new-book" do
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
      # clumsy kludge for when GoogleBooks returns a 
      @new_book = { author: "AUTHOR NOT FOUND", 
                    title: "TITLE NOT FOUND", 
                    year: "",
                    last_page: "",
                    cover: nil,
                    link: "" }
    end
    @isbn = params[:isbn] # sometimes google doesn't return one.
    mustache :new_book_post
  end

  post "/add-book" do
    @page_title = "Saving #{params[:title]}"
    saved_book = Book.new
    saved_book.attributes = { author: params[:author], title: params[:title], isbn: params[:readonlyISBN], cover: params[:cover], url: params[:link], year: params[:year], users: [@user], slug: "#{params[:title]}_#{params[:year]}".parameterize.underscore }
    begin
      saved_book.save
      redirect "/books/#{saved_book.slug}"
    rescue DataMapper::SaveFailureError => e
      mustache :error_report, locals: { e: e, validation: saved_book.errors.values.join(', ') }
    rescue StandardError => e
      mustache :error_report, locals: { e: e }
    end
  end

  get "/books/:slug" do
    @book = Book.first slug: params[:slug]
    @page_title = "#{@book.title}"
    if @book.nil?
      redirect '/books'
    else
      mustache :book_show
    end
  end

  get "/books" do
    @page_title = "All Books"
    @books = Book.all
    mustache :books_show
  end

  get "/about" do
    @page_title = "About"
    mustache :about
  end

  def get_bbox(bbox)
    if bbox.class == Hash
      bbox.values.to_s
    end
  end

  def create_bounding_box(place)
    # This doesn't actually seem to build a useful polygon.
    place.bounding_box = BoundingBox.new
    if place.bounding_box_string =~ /^\[.*\]$/
      bbox = place.bounding_box_string.gsub(/^\[/, "").gsub(/\]$/, "").split(", ")
      place.bounding_box.geom = GeoRuby::SimpleFeatures::Polygon.from_coordinates([
        [ bbox[0], bbox[1] ],
        [bbox[0], bbox[2]],
        [bbox[3], bbox[2]],
        [bbox[3], bbox[1]]
      ], 4326)
    else
      place.bounding_box.geom = nil
    end
    place.save
  end

end
