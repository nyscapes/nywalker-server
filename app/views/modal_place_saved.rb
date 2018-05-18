# frozen_string_literal: true
class App
  module Views

    class ModalPlaceSaved < Naked

      def place_name
        @place.name
      end

      def place_slug
        @place.slug
      end

    end
  end
end
