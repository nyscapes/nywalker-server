# Rakefile

# From: https://gist.github.com/jeffreyiacono/1772989

require './app'

desc 'Create JSON files to reduce db lookups.'
task :jsonify do

  def build_places(instances) 
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

  json_counts_file = "json_counts.yml"
  if File.exists? json_counts_file
    json_counts = YAML::load_file json_counts_file
  else
    raise "No json_counts file."
  end

  place_count = Place.all.count
  if json_counts[:places] != Place.count
    places = build_places(Instance.all)
    File.open("public/json/all_places.json","w") do |f|
      f.write(places.to_json)
      puts "Wrote all_places.json"
    end

    Book.each do |book|
      @book = book
      places = build_places(Instance.all(book: book))
      File.open("public/json/#{book.slug}.json", "w") do |f|
        f.write(places.to_json)
        puts "Wrote #{book.slug}.json"
      end
    end

    json_counts[:places] = place_count
    File.open(json_counts_file, 'w') do |f|
      f.puts YAML::dump(json_counts)
    end
  else
    puts "No new places detected at #{Time.now}"
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

