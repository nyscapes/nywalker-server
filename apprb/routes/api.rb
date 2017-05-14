class App
  namespace '/api/v1' do

    configure do
      mime_type :api_json, 'application/vnd.api+json'
    end

    helpers do
      def parse_request_body
        # Rack::Lint::InputWrapper doesn't respond to #size!
        # return unless request.body.respond_to?(:size) &&
        #   request.body.size > 0
        return unless request.body.read.size > 0

        halt 415 unless request.content_type &&
          request.content_type[/^[^;]+/] == mime_type(:api_json) 

        request.body.rewind
        JSON.parse(request.body.read, symbolize_names: true)
      end

      def serialize_models(models, options = {})
        options[:is_collection] = true
        JSONAPI::Serializer.serialize(models, options).merge @meta
      end

      def serialize_model(model, options = {})
        options[:is_collection] = false
        options[:skip_collection_check] = true
        JSONAPI::Serializer.serialize(model, options).merge @meta
      end

      def build_total_pages(model, page_size)
        if page_size.respond_to?(:to_i) && page_size.to_i != 0
          @meta[:meta][:total_pages] = (model.count / page_size.to_f).ceil
        else
          halt 400
        end
      end

      def error_invalid
        status 400
        { "error": "invalid_grant" }.to_json
      end

      def paginator(collection, params)
        page = params[:data_page].to_i
        page_size = params[:page_size].to_i
        # model.order(:id).extension(:pagination).paginate(page, page_size).all
        collection.paginate(page: page, per_page: page_size)
      end
      
    end

    before do
      halt 406 unless request.preferred_type.entry == mime_type(:api_json)
      @data = parse_request_body
      content_type :api_json
      @meta = { meta: 
        { copyright: "Copyright 2017 Moacir P. de Sá Pereira", 
          license: "See http://github.com/nyscapes/nywalker", 
          authors: ["Moacir P. de Sá Pereira"] 
        } 
      }
    end

  # Books
    get '/books' do
      serialize_models(Book.all.sort_by{ |b| b.instance_count }.reverse).to_json
    end

  # Instances

  # Places
    get '/places' do
      if params[:data_page] && params[:page_size]
        build_total_pages(Place, params[:page_size])
        places = paginator(Place.all.sort_by{ |p| p.instance_count }.reverse, params)
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

  # USER

    get '/users/:user_id' do
      user = User[params[:user_id].to_i]
      not_found if user.nil?
      serialize_model(user).to_json
    end


  # AUTH

    post '/token' do
      if @data.nil? || @data.length == 0
        status 400
        { "error": "no_request_payload" }.to_json
      elsif @data[:grant_type] == "password"
        user = User.where(username: @data[:username]).first
        if user.nil?
          status 400
          error_invalid
        elsif user.authenticate(@data[:password]) == user
          status 200
          { "access_token": "secret!", "account_id": user.id }.to_json
        else
          status 400
          error_invalid
        end
      else
        status 400
        { "error": "unsupported_grant_type" }.to_json
      end
    end

    post '/revoke' do
      status 200
    end

  end
end
