class App
  module Views

    class InstanceNew < Layout

      def page
        @last_instance.nil? ? 1 : @last_instance.page
      end

      def sequence
        @last_instance.nil? ? 1 : @last_instance.sequence + 1
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
