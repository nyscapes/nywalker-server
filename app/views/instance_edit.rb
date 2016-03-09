class App
  module Views

    class InstanceEdit < Layout

      def form_button
        "Edit saved instance"
      end

      def page
        @instance.page
      end

      def place_name
        @instance.place.name
      end

      def place_name_in_text
        @instance.text
      end

      def sequence
        @instance.sequence
      end

      def id
        @instance.id
      end

      def special
        @instance.special
      end

      def book_title
        @book.title
      end

      def book_slug
        @book.slug
      end

      def special_field
        @book.special.field unless @book.special.nil?
      end

      def special_help_text
        @book.special.help_text unless @book.special.nil?
      end

      def nicknames
        @nicknames
      end

      def form_source
        "modal"
      end

      def note
        @instance.note
      end

    end
  end
end
