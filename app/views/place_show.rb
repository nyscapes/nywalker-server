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

    end
  end
end
