class App
  module Views

    class PlacesShow < Layout
      include ViewHelpers

      def places
        @places.map{ |p| { 
          slug: p.slug,
          lat: p.lat,
          lon: p.lon,
          name: p.name,
          instances: p.instances.count,
          flagged: p.flagged,
          note: not_empty(p.note),
          confidence_class: confidence_class(p)
        } }
      end

      def confidence_class(place)
        case place.confidence
        when "2" then "bg-warning"
        when "1" then "bg-warning"
        when "0" then "bg-danger"
        else ""
        end
      end

    end
  end
end
