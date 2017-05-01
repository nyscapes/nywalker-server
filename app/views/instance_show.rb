class App
  module Views

    class InstanceShow < Layout
      include ViewHelpers

      def book_slug
        @book.slug
      end

      def page
        @instance.page
      end

      def sequence
        @instance.sequence
      end

      def place_slug
        @instance.place.slug
      end

      def place_name
        @instance.place.name
      end

      def text
        @instance.text
      end

      def owner
        @instance.user.name
      end

      def flagged
        @instance.flagged
      end

      def note
        @instance.note
      end

      def special
        @instance.special
      end

      def id
        @instance.id
      end

      def special_field
        @book.special.field unless @book.special.nil?
      end

      def special_help_text
        @book.special_help_text unless @book.special_help_text.nil?
      end

      def added_on
        @instance.added_on
      end

      def lat
        @instance.place.lat
      end

      def lon
        @instance.place.lon
      end

      def previous_id
        @previous_instance.id unless @previous_instance.nil?
      end

      def next_id
        @next_instance.id unless @next_instance.nil?
      end

    end
  end
end
