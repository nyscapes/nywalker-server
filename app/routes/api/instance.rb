class App
  namespace '/api/v1' do

    post '/instances' do
      if @data.nil? || @data.length == 0
        status 400
        { "error": "some_error_with_payload" }.to_json
      else
        puts @data
        {}.to_json
      end
    end

  end
end

