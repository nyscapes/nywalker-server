class App
  namespace '/api/v1' do

  require_relative 'all'

    post '/places' do
      # needs a name and a slug. Latter must be unique.
      halt 400, { error: "invalid_type" }.to_json if @data[:type] != "place"
      puts @data
    end

    patch '/places/:place_id' do
      place = Place[params[:place_id]]
      halt 404 if place.nil?
      # puts @data
      # @data.to_json
      #
    end



  end

end
