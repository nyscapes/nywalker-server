# Rakefile

# From: https://gist.github.com/jeffreyiacono/1772989

require './app'

desc 'Create redis cache of books'
task :cache_books do
  redis = Redis.new
  App::RakeMethods.cache_list_of_books(redis)
end

desc 'Create redis cache of instance'
task :cache_instances do
  redis = Redis.new
  App::RakeMethods.cache_instances_of_all_books(redis)
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
    places = App::RakeMethods.build_places(Instance.all)
    # puts "[#{Time.now}]: Built all places."
    File.open("public/json/all_places.json","w") do |f|
      f.write(places.to_json)
    end

    Book.each do |book|
      @book = book
      # puts "[#{Time.now}]: Starting run on #{book.title}"
      places = App::RakeMethods.build_places(Instance.all(book: book))
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
    sprockets = App.settings.sprockets
    asset = sprockets['application.js']
    outpath = File.join(App.settings.assets_path)
    outfile = Pathname.new(outpath).join('application.js')

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    # asset.write_to("#{outfile}.gz")
    puts "Compiled JS assets"
  end
  
  desc 'Compile CSS assets'
  task :compile_css do
    sprockets = App.settings.sprockets
    asset = sprockets['application.css']
    outpath = File.join(App.settings.assets_path)
    outfile = Pathname.new(outpath).join('application.css')

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    # asset.write_to("#{outfile}.gz")
    puts "Compiled CSS assets"
  end

end

