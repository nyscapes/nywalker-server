class App
  namespace '/api/v1' do

    get '/nicknames' do
      if params[:q]
        nicks = Nickname.where(name: /#{params[:q]}/i).all.sort_by{ |n| n[:instance_count] }.reverse
      else
        nicks = Nickname.all.sort_by{ |n| n[:instance_count] }.reverse
      end
      status 200
      serialize_models(nicks).to_json
    end

    get '/nicknames-list' do
      status 200
      Nickname.map{ |n| { list_string: n.list_string, count: n.instance_count } }.sort_by{ |n| n[:count] }.reverse.to_json
    end

  end
end
