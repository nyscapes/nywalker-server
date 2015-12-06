class App

  # ALL

  get "/places" do
    @page_title = "All places"
    @places = Place.all
    mustache :places_show
  end

  # CREATE

  get "/places/new" do
    protected_page
    @page_title = "Add New Place"
    mustache :place_new
  end

  post "/places/add" do
    protected_page
    new_place = Place.new
    new_place.attributes = { name: params[:name], lat: params[:lat], lon: params[:lon], source: params[:source], confidence: params[:confidence], user: @user, added_on: Time.now, what3word: params[:w3w], slug: params[:name] }
    if new_place.source == "GeoNames"
      new_place.bounding_box_string = params[:bbox]
      new_place.geonameid = params[:geonameid]
    end
    if new_place.lat == "" && new_place.lon == ""
      new_place.lat = nil
      new_place.lon = nil
      new_place.confidence = 0
    end
    begin
      new_place.save
      Nickname.create(name: new_place.name, place: new_place)
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

  # READ

  get "/places/:place_slug" do
    @page_title = "#{place.name}"
    @books = Book.all(instances: Instance.all(place: place))
    mustache :place_show
  end

  # UPDATE

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
 
  # DESTROY

end
