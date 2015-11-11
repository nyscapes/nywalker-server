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

      def confidence
        @place.confidence
      end

      def books
        @books.map{|b| { book_slug: b.slug, book_title: b.title, instances: (Instance.all(place: @place) & Instance.all(book: b)).length } }
      end

      def source_link
        if @place.source == "GeoNames"
          url = "http://www.geonames.org/#{@place.geonameid}/"
          text = "GeoNames (#{@place.geonameid})"
        elsif @place.source =~ /\A#{URI::regexp(['http', 'https'])}\z/
          url = @place.source
          text = @place.source
        else
          url = nil
          text = @place.source
        end
        string = text
        string.gsub(/^/, "<a href='#{url}' target='_blank'>").gsub(/$/, " <span class='glyphicon glyphicon-new-window' aria-hidden='true'></span></a>") unless url.nil?
      end

      def nicknames_sentence
        names = @place.nicknames.map{|n| n.name}
        names.to_sentence
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
