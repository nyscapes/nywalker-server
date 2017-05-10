class App
  namespace '/api/v1' do

    before do
      content_type 'application/json'
    end

  # Books
    get '/books' do
      Book.to_json
    end

  # Instances

  # Places
    get '/places' do
      Place.to_json(except: :geom)
    end

  end
end
