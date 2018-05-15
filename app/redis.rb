class App

  post "/reload-autofill" do
    nicknames_list(Nickname.sorted_by_instance_count.map{ |n| { string: n.list_string, instance_count: n.instance_count } })
    nicknames = nicknames_list.map{ |n| n[:string] }
    { nicknames: nicknames }.to_json
  end

  set :redis, Redis.new
  set :nicknames_list, Proc.new { Nickname.sorted_by_instance_count.map{ |n| { string: n.list_string, instance_count: n.instance_count } } }

  def nicknames_list(newlist = nil)
    nick_key = "user-#{@user.username}-nicknames-list"
    if newlist.nil?
      nicks = redis.cache(
        key: nick_key,
        expire: 1800,
        timeout: 60
      ) do
        Nickname.sorted_by_instance_count.map{ |n| { string: n.list_string, instance_count: n.instance_count } }.to_json
      end
    else
      redis.set nick_key, newlist.to_json
      nicks = redis.get nick_key
    end
    JSON.parse(nicks, symbolize_names: true).sort_by { |n| n[:instance_count] }.reverse
  end

end

class Redis

  def cache(params)
    key = params[:key] || raise(":key parameter is required!")
    expire = params[:expire] || nil
    recalculate = params[:recalculate] || nil
    timeout = params[:timeout] || nil
    default = params[:default] || nil

    if (value = get(key)).nil? || recalculate
      begin
        value = Timeout::timeout(timeout) { yield(self) }
      rescue Timeout::Error
        value = default
      end

      set(key, value)
      expire(key, expire) if expire
      value
    else
      value
    end
  end

end

