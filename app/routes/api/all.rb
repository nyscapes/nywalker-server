class App
  namespace '/api/v1' do

    %w(books places users instances nicknames).each do |route|

      get "/#{route}" do
        model = route.singularize.classify.constantize
        #if params[:q] # do a query
        if params[:data_page] && params[:page_size]
          build_total_pages(model, params[:page_size])
          items = paginator(model.all, params)
          serialize_models(items).to_json
        else
          serialize_models(model.all).to_json
        end
      end

      get "/#{route}/:id" do
        model = route.singularize.classify.constantize
        item = model[params[:id].to_i]
        not_found if item.nil?
        serialize_model(item).to_json

      end
      
    end
  end
end

