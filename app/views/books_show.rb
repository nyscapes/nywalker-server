class App
  module Views

    class BooksShow < Layout
      include ViewHelpers

      def books
        @books.map{ |b| { author: b.author, title: b.title, slug: b.slug, link: b.url, external_link: external_link_glyph(b.url), year: b.year } }
      end

    end
  end
end
