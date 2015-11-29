class App
  module Views

    class BookShow < Layout

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
        @instances.map{ |i| {page: i.page, sequence: i.sequence, place_name: i.place.name, place_slug: i.place.slug} }
      end

      def places
        @instances.places.map{ |p| { lat: p.lat, lon: p.lon, name: p.name } }
      end

    end
  end
end
