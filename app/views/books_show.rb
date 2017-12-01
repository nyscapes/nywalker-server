class App
  module Views

    class BooksShow < Layout
      include ViewHelpers

      def last_updated
        @last_updated
      end

      def books
        @books.map do |b| 
          { 
            author: b[:author], 
            title: b[:title], 
            slug: b[:slug], 
            link: b[:url], 
            external_link: external_link_glyph(b[:url]), 
            year: b[:year], 
            users: b[:user_sentence], 
            instances: b[:instances],
            pages: b[:total_pages],
            instances_per_page: get_instances_per_page(b[:total_pages], b[:instances]),
            permitted: ( admin? || Book[b[:id]].users.include?(@user) )
          } 
        end
      end

    end
  end
end
