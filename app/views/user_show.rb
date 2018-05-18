# frozen_string_literal: true
class App
  module Views

    class UserShow < Layout

      def name
        @this_user.name
      end

      def username
        @this_user.username
      end

      def email
        @this_user.email
      end

      def added_on
        @this_user.added_on
      end

      def admin
        @this_user.admin?
      end

      def instance_count
        @this_user.instances.count
      end

      def place_count
        @this_user.places.count
      end

      def book_count
        @this_user.books.count
      end
      
      def instances
        @this_user.instances.map{ |i| { 
          i_id: i.id,
          i_book_slug: i.book.slug,
          i_book: i.book.title,
          i_place_slug: i.place.slug,
          i_place: i.place.name,
          i_page: i.page,
          i_sequence: i.sequence
        } }
      end

      def places
        @this_user.places.map{ |p| {
          p_slug: p.slug,
          p_name: p.name,
          p_instances: p.instances.count
        } }
      end

      def books
        @this_user.books.map{ |b| {
          b_slug: b.slug,
          b_title: b.title,
          b_instances: b.instances.count
        } }
      end

      def change_password
        @user.admin? || @user == @this_user
      end

    end
  end
end
