# frozen_string_literal: true
require './app'
Place.each do |p|
  if p.geom.nil?
    unless p.lat.nil? || p.lon.nil?
      p.geom = GeoRuby::SimpleFeatures::Point.from_x_y(p.lon, p.lat, 4326)
      p.save
    end
  end
end
