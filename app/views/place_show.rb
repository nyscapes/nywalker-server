class App
  module Views

    class PlaceShow < Layout
      include ViewHelpers

      def object_id_for_flag
        @place.id
      end

      def name
        @place.name
      end

      def note?
        @place.note.length > 0
      end

      def note
        @place.note
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

      def slug
        @place.slug
      end

      def type
        # object.class.to_s.downcase
        "place"
      end

      def flagged
        @place.flagged
      end

      def source
        @place.source
      end

      # def source_button
      #   @place.source =~ URI::regexp(['http', 'https'])
      # end

      def bounding_box
        @place.bounding_box_string
      end

      def geonameid
        @place.geonameid
      end

      def w3w
        @place.what3word
      end

      def nicknames
        Nickname.where(place: @place).map(:name).to_sentence
      end

      def books
        @books.map{|b| { book_slug: b.slug, book_title: b.title, instances: Instance.where(place: @place).where(book: b).all.length } }
      end

      def source_link
        if @place.source == "GeoNames"
          url = "http://www.geonames.org/#{geonameid}/"
          text = "GeoNames (#{geonameid})"
        elsif @place.source =~ /\A#{URI::regexp(['http', 'https'])}\z/
          url = @place.source
          text = @place.source
        else
          url = nil
          text = @place.source
        end
        if url.nil?
          text
        else
          "<a href='#{url}' target='_blank'>#{text} <span class='fa fa-external-link' aria-hidden='true'></span></a>"
        end
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

      def map_height
        "300px;"
      end
    end
  end
end
