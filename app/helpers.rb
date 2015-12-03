class App
  module ViewHelpers

    def admin
      @admin
    end

    def stylesheets
      @css
    end

    def javascripts
      @js
    end

    def add_book_button
      "<a href='/new-book' class='btn btn-primary btn-lg'>Add New Book</a>"
      # "<a href='/new-book' class='btn btn-primary btn-lg disabled'>Add New Book (disabled for demo)</a>"
    end

    def external_link_glyph(link)
      "<a href='#{link}' target='_blank'><span class='glyphicon glyphicon-new-window' aria-hidden='true'></span></a>"
    end

    def rendered_flash
      @rendered_flash
    end

    def user_sentence(userlist)
      list = userlist.map do |user|
        user.name
      end
      list.to_sentence
    end

    def logged_in
      @user
    end

    def book_permitted
      admin? || @book.users.include?(@user) 
    end

    def place_permitted
      admin? || @place.user == @user
    end

    def user_name
      if @user
        @user.name
      else
        "Guest"
      end
    end

    def admin?
      if @user
        @user.admin?
      end
    end

  end
end
