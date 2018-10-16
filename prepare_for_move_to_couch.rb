# Load in database & pretty print
require "./app/model"
# require "pp"

# Get all places
places = Place.all

# Add associated data
places.each do |place|
  place[:nix] = place.nicknames
  place[:inst] = place.instances
end

# Create regular ruby objects
plain_places = places.map do |place|
  { 
    id: place.id,
    slug: place.slug,
    name: place.name,
    added_on: place.added_on,
    lat: place.lat,
    lon: place.lon,
    confidence: place.confidence,
    source: place.source,
    geonameid: place.geonameid,
    what3word: place.what3word,
    bounding_box_string: place.bounding_box_string,
    user_id: place.user_id,
    flagged: place.flagged,
    note: place.note,
    geom: place.geom,
    modified_on: place.modified_on,
    nicknames: place[:nix].to_json 
  }
end

File.open("data/places.json", "w") do |f| 
  # PP.pp plain_places.to_json, f
  f.puts plain_places.to_json
end
