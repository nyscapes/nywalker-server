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

    get '/places/:place_id' do
      place = Place[params[:place_id].to_i]
      not_found if place.nil?
      serialize_model(place).to_json
    end

    post '/places/:place_id' do
      if @data.nil? || @data.length == 0
        status 400
        { "error": "no_request_payload" }.to_json
      else
        place = Place[params[:place_id]]
        404 if place.nil?
        # puts @data
        # @data.to_json
        #
      end
    end



  end

end
