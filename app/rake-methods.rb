class App
  module RakeMethods

    def self.cache_list_of_books(redis = Redis.new)
      books = Book.all.sort_by{ |book| book.title }
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

    def self.cache_instances_of_all_books(redis = Redis.new)
      Book.each do |book|
        App::RakeMethods.cache_list_of_instances(book, redis)
      end
    end

    def self.cache_list_of_instances(book, redis = Redis.new)
      instances = Instance.all_sorted_for_book(book)
      unless redis.hmget("book-#{book.slug}-instances", "count")[0].to_i == instances.count
        list = instances.map do |i|
          {
            page: i.page,
            sequence: i.sequence,
            place_name: i.place.name,
            place_slug: i.place.slug,
            id: i.id,
            owner: i.user.name,
            flagged: i.flagged,
            note: i.note,
            text: i.text,
            special: i.special
          }
        end
        redis.hmset "book-#{book.slug}-instances", "last-updated", Time.now, "list", list.to_json, "count", list.length
      end
    end
 
    def self.build_places(instances) 
      instances.map{ |i| i.place }.uniq.select{ |i| i.confidence != "0" }.map do |p|
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

    def self.compile_js
      sprockets = App.settings.sprockets
      asset = sprockets['application.js']
      outpath = File.join(App.settings.assets_path)
      outfile = Pathname.new(outpath).join('application.js')

      FileUtils.mkdir_p outfile.dirname

      asset.write_to(outfile)
    end
  #
  #
  #
  end
end
