class App
  module Views

    class BooksShow < Layout
      include ViewHelpers

      def books
        @books.map{ |b| { author: b.author, 
            title: b.title, 
            slug: b.slug, 
            link: b.url, 
            external_link: external_link_glyph(b.url), 
            year: b.year, 
            users: user_sentence(b.users), 
            instances: b.instances.length,
            pages: b.total_pages,
            instances_per_page: get_instances_per_page(b),
            permitted: ( admin? || b.users.include?(@user) )
        } }
      end

    end
  end
end
