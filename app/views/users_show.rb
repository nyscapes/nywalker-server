# frozen_string_literal: true
class NYWalkerServer
  module Views

    class UsersShow < Layout
      include ViewHelpers

      def users
        @users.map{ |u| {
          username: u.username,
          name: u.name,
          email: u.email,
          admin: u.admin,
          instances: u.instances.count,
          books: u.books.count
        } }
      end

    end
  end
end
