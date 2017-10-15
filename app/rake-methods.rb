class App
  module RakeMethods

    # def redis
    #   @redis ||= Redis.new
    # end

    def self.cache_list_of_books(redis = Redis.new)
      books = Book.all(order: [:title.asc])
      list = books.map do |b|
        {
          author: b.author,
          title: b.title,
          id: b.id,
          slug: b.slug,
          url: b.url,
          year: b.year,
          user_sentence:  b.users.map{ |u| u.name }.to_sentence,
          instances: b.instances.length,
          total_pages: b.total_pages
        }
      end
      redis.hmset "book-list", "last-updated", Time.now, "list", list.to_json
    end
 
    def self.build_places(instances) 
      instances.all.places.all(:confidence.not => 0).map do |p|
        { lat: p.lat, lon: p.lon, 
          name: p.name, 
          count: p.instances_per.count,
          place_names: p.instances_by_names,
          place_names_sentence: p.names_to_sentence,
          slug: p.slug,
          confidence: p.confidence
        } 
      end
    end

  #
  #
  #
  end
end
