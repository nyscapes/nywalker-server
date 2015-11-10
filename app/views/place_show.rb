class App
  module Views

    class PlaceShow < Layout

      def name
        @place.name
      end

      def user
        @place.user.name
      end

      def added_on
        @place.added_on
      end

      def lat
        @place.lat
      end

      def lon
        @place.lon
      end

      def bounding_box_polygon
        if @place.bounding_box_string =~ /^\[.*\]$/
          string = "var boundingBox = L.polygon(["
          bbox = @place.bounding_box_string.gsub(/^\[/, "").gsub(/\]$/, "").split(", ").map{ |n| n.to_f }
          string = string + "[#{bbox[1]}, #{bbox[0]}],"
          string = string + "[#{bbox[1]}, #{bbox[3]}],"
          string = string + "[#{bbox[2]}, #{bbox[3]}],"
          string = string + "[#{bbox[2]}, #{bbox[0]}]"
          string = string + "], {color: '#fff', opacity: 0.8}).addTo(map);\n"
          string = string + "map.fitBounds([[#{bbox[1]}, #{bbox[3]}], [#{bbox[2]}, #{bbox[0]}]]);\n"
        else
          ""
        end
      end

    end
  end
end
