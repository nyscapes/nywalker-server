# Rakefile

# From: https://gist.github.com/jeffreyiacono/1772989

require './app'

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
