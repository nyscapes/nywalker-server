require 'georuby'
require 'geo_ruby/ewk'
require './model'

user = User.first name: "Moacir"

CSV.foreach("baburnama_places.csv", headers: true) do |row|
  # puts row
  unless row["status"] == "x"
    if Place.first name: row["canonical_name"]
      puts "#{row["canonical_name"]} seems to already be added"
    else
      p = Place.new
      p.attributes = { name: row["canonical_name"], slug: row["canonical_name"], 
        note: "baburnama:{type:'#{row['type']}', note:'#{row['note']}', instances:'#{row['instances']}'}",
        user: user,
        added_on: Time.now
      }
      if row["status"] == "?"
        p.lat = row["latitude"]
        p.lon = row["longitude"]
        p.confidence = "1"
        p.source = "Thackston"
        p.geom = GeoRuby::SimpleFeatures::Point.from_x_y(p.lon, p.lat, 4326)
      else
        p.confidence = "0"
      end
      begin
        p.save
        puts "Saved #{p.name}"
        Nickname.create place: p, name: p.name
        unless row["aka"].nil?
          row["aka"].split(",").each{ |nick| Nickname.create place: p, name: nick }
        end
      rescue DataMapper::SaveFailureError => e
        puts e
        puts p.errors.values.join(', ')
      end
    end
  end
end
