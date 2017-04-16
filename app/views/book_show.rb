class App
  module Views

    class BookShow < Layout
      include ViewHelpers

      def external_link
        external_link_glyph(@book.url)
      end

      def id
        @book.id
      end

      def author
        @book.author
      end

      def title
        @book.title
      end

      def year
        @book.year
      end

      def isbn
        @book.isbn
      end

      def cover
        @book.cover
      end

      def special_field
        @book.special.field unless @book.special.nil?
      end

      def cover_alt
        "#{title}, #{year}"
      end

      def link
        @book.url
      end

      def slug
        @book.slug
      end

      def instances
        @instances.map{ |i| {
          page: i.page, sequence: i.sequence, place_name: i.place.name, place_slug: i.place.slug, instance_id: i.id,
          instance_permitted: ( admin? || i.user == @user ),
          owner: i.user.name,
          flagged: i.flagged,
          note: not_empty(i.note),
          special: i.special
        } }
      end

      def instance_count
        @instances.length
      end

      def instances_per_page
        get_instances_per_page(@book)
      end

    end
  end
end
