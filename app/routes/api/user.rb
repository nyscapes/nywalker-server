class App
  namespace '/api/v1' do

    get '/users/:user_id' do
      user = User[params[:user_id].to_i]
      not_found if user.nil?
      serialize_model(user).to_json
    end

  end
end
