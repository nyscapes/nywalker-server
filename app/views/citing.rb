class App
  module Views
    class Citing < Layout
      include ViewHelpers

      def today
        Time.now.strftime("%e %B %Y")
      end

      def cite_books
        @books.map{ |book| {
          authors: authors(book),
          book_title: book.title,
          book_author: book.author,
          book_slug: book.slug
          }
        }
      end

      def authors(book) # A DataMapper list of Users
        users = Instance.all_users_sorted_by_count(book).map{ |u| User[u.user_id] }
        authors_string(users)
      end

      def all_authors
        users = Instance.all_users_sorted_by_count.map{ |u| User[u.user_id] }
        authors_string(users)
      end

      def authors_string(users)
        first_author = users.shift
        author_names = [first_author.fullname_lastname_first]
        if users.length > 0
          users.each do |user|
            author_names << user.fullname
          end
        end
        author_names.to_sentence
      end

    	
    end
  end
end
