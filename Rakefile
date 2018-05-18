# Rakefile

# From: https://gist.github.com/jeffreyiacono/1772989

require './nywalker-server'

desc 'Create redis cache of books'
task :cache_books do
  redis = Redis.new
  NYWalkerServer::RakeMethods.cache_list_of_books(redis)
end

desc 'Create redis cache of instance'
task :cache_instances do
  redis = Redis.new
  NYWalkerServer::RakeMethods.cache_instances_of_all_books(redis)
end

desc 'Resync instance_counts for Nicknames'
t1 = Time.now
task :resync_nicks do
  Nickname.each do |nick|
    count = nick.instance_count_query
    if count != nick.instance_count
      puts "[#{Time.now}] instance count for #{nick.name} was off by #{nick.instance_count - count}"
      nick.update(instance_count: count)
    end
  end
t2 = Time.now
puts "[#{t2}] Nick resync completed in #{t2 - t1} seconds."
end

desc 'Pretend to be an api'
task :api do
  Dir.mkdir("public/api") unless File.exists? "public/api"
  Book.each do |book|
    Dir.mkdir("public/api/#{book.slug}") unless File.exists? "public/api/#{book.slug}"
    instances = Instance.all(book: book, order: [:page.asc, :sequence.asc]) 
    geojson = { type: "FeatureCollection" }
    geojson[:features] = instances.map do |instance|
      { type: "Feature",
        geometry: {
          type: "Point",
          coordinates: [instance.place.lon, instance.place.lat]
        },
        properties: {
          id: instance.id,
          page: instance.page,
          sequence: instance.sequence,
          text: instance.text,
          special: instance.special,
          flagged: instance.flagged,
          added_on: instance.added_on,
          added_by: instance.user.name,
          place_properties: {
            id: instance.place.id,
            name: instance.place.name,
            note: instance.place.note,
            flagged: instance.place.flagged,
            source: instance.place.source,
            geonameid: instance.place.geonameid,
            confidence: instance.place.confidence,
            added_on: instance.place.added_on,
            added_by: instance.place.user.name,
            slug: instance.place.slug
          }
        }
      }
    end
    File.open("public/api/#{book.slug}/instances.json","w") do |f|
        f.write(geojson.to_json)
    end

    places = instances.places.all(:confidence.not => 0)
    geojson = { type: "FeatureCollection" }
    geojson[:features] = places.map do |place|
      is_by_place = instances.all(place: place)
      i_pages = is_by_place.map{ |i| i.page }
      #count = place.instances.select{ |i| i.book_id == book.id }.count
      nicknames = instances.select{ |i| i.place == place }.map{ |i| i.text }.uniq.to_sentence
      { type: "Feature",
        geometry: {
          type: "Point",
          coordinates: [place.lon, place.lat]
        },
        properties: {
          id: place.id,
          name: place.name,
          instance_count: is_by_place.count,
          pages: i_pages,
          average_instance_page: is_by_place.map{ |i| i.page }.mean,
          instance_stdev: is_by_place.map{ |i| i.page }.standard_deviation,
          average_instance_page_pct: is_by_place.map{ |i| i.page }.mean/book.total_pages,
          instance_stdev_pct: is_by_place.map{ |i| i.page }.standard_deviation/book.total_pages,
          note: place.note,
          flagged: place.flagged,
          source: place.source,
          geonameid: place.geonameid,
          confidence: place.confidence,
          nicknames: nicknames,
          added_on: place.added_on,
          added_by: place.user.name,
          slug: place.slug
        }
      }
    end
    File.open("public/api/#{book.slug}/places.json","w") do |f|
        f.write(geojson.to_json)
    end
  end
end

desc 'Create JSON files to reduce db lookups.'
task :jsonify do

  # puts "[#{Time.now}]: looking for json_counts"
  json_counts_file = "json_counts.yml"
  if File.exists? json_counts_file
    json_counts = YAML::load_file json_counts_file
  else
    raise "No json_counts file."
  end

  place_count = Place.count
  # puts "[#{Time.now}]: Starting run on #{place_count} places"
  if json_counts[:places] != place_count
    t1 = Time.now
    places = NYWalkerServer::RakeMethods.build_places(Instance.all)
    # puts "[#{Time.now}]: Built all places."
    File.open("public/json/all_places.json","w") do |f|
      f.write(places.to_json)
    end

    Book.each do |book|
      @book = book
      # puts "[#{Time.now}]: Starting run on #{book.title}"
      places = NYWalkerServer::RakeMethods.build_places(Instance.where(book: book).all)
      # puts "[#{Time.now}]: Built all places for #{book.title}."
      File.open("public/json/#{book.slug}.json", "w") do |f|
        f.write(places.to_json)
      end
    end

    json_counts[:places] = place_count
    File.open(json_counts_file, 'w') do |f|
      f.puts YAML::dump(json_counts)
    end
    puts "[#{Time.now}]: Wrote json files for #{place_count} places in #{Time.now - t1} seconds."
  else
    puts "[#{Time.now}]: No new places detected."
  end
end

namespace :assets do
  desc 'Compile assets'
  task compile: [:compile_js, :compile_css] do
  end

  desc 'Compile JS assets'
  task :compile_js do
    NYWalkerServer::RakeMethods.compile_js
    puts "Compiled JS assets"
  end
  
  desc 'Compile CSS assets'
  task :compile_css do
    sprockets = NYWalkerServer.settings.sprockets
    asset = sprockets['application.css']
    outpath = File.join(NYWalkerServer.settings.assets_path)
    outfile = Pathname.new(outpath).join('application.css')

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    # asset.write_to("#{outfile}.gz")
    puts "Compiled CSS assets"
  end
end

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    require "sequel"
    Sequel.extension :migration
    db = Sequel.connect(ENV['DATABASE_URL'])
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "db/migrations")
    end
  end
end
