class App
  namespace '/api/v1' do

    get '/places' do
      if params[:data_page] && params[:page_size]
        build_total_pages(Place, params[:page_size])
        places = paginator(Place.all.sort_by{ |p| p.instances.count }.reverse, params)
        serialize_models(places).to_json
      else
        if params[:slug]
          place = Place.where(slug: params[:slug]).first
          not_found if place.nil?
          serialize_model(place, include: 'nicknames').to_json
        else 
          if params[:name]
            places = Place.where(name: /#{params[:name]}/i)
          else
            places = Place.all
          end
          places = places.sort_by{ |p| p.instance_count }.reverse
          serialize_models(places).to_json
        end
      end
    end

    post '/places' do
      if @data.nil? || @data.length == 0
        status 400
        { "error": "some_error_with_payload" }.to_json
      else
        puts @data
        @data.to_json
      end
    end

  end

end
