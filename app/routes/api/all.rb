class App
  namespace '/api/v1' do

    before do
      @model = model unless request.path_info == "/api/v1/"
    end

    %w(books places users instances nicknames).each do |route|

      helpers do
        def model
          @model ||= request.path_info.gsub(/^\/api\/v1\/(\w*)(\/*.*$)/, '\1' ).singularize.classify.constantize
        end
      end

      get "/#{route}" do
        #if params[:q] # do a query
        if params[:data_page] && params[:page_size]
          build_total_pages(@model, params[:page_size])
          items = paginator(@model.all, params)
          serialize_models(items).to_json
        else
          serialize_models(@model.all).to_json
        end
      end

      get "/#{route}/:id" do
        item = @model[params[:id].to_i]
        not_found if item.nil?
        serialize_model(item).to_json

      end
      
    end
  end
end

