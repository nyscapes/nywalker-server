# frozen_string_literal: true
class NYWalkerServer

  # The RakeMethods module provides a series of methods that are designed to be
  # invoked as rake tasks but are sometimes called from the server as well. 
  module RakeMethods

    # Given a set of Instances, build an array of Places.
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

  end
end
