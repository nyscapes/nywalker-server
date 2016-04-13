class App
  module Views
    class About < Layout
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
        users = book.instances.user.uniq
        user_count = {}
        users.each do |user|
          user_count[user] = book.instances.select{|i| i.user == user}.count
        end
        authors_string(user_count)
      end

      def all_authors
        users = Instance.all.user.uniq
        user_count = {}
        users.each do |user|
          user_count[user] = Instance.all.select{|i| i.user == user}.count
        end
        authors_string(user_count)
      end

      def authors_string(user_count) # An Array of [[User, n], [User, n]]
        sorted_array = user_count.sort_by{ |k,v| v }.map{|a| a[0]}
        first_author = sorted_array.pop
        author_names = [fullnamelastnamefirst(first_author)]
        if sorted_array.length > 0
          sorted_array.reverse.each do |user|
            unless user.firstname.nil? && user.lastname.nil?
              author_names << "#{user.firstname} #{user.lastname}"
            else
              author_names << "#{user.name}"
            end
          end
        end
        author_names.to_sentence
      end

      def fullnamelastnamefirst(user)
        if user.lastname.nil? && user.firstname
          user.firstname
        elsif user.firstname.nil? && user.lastname
          user.lastname
        elsif user.firstname.nil? && user.lastname.nil?
          user.name
        else
          user.lastname + ", " + user.firstname
        end
      end
    	
    end
  end
end
