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

      def book_title
        @book.title
      end

      def book_slug
        @book.slug
      end

      def nicknames
        @nicknames
      end

      def form_source
        "modal"
      end

    end
  end
end