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
    
    def flag_modal_button
      <<-EOF
          <button type="button" class="btn btn-danger btn-default" data-toggle="modal" data-target="#addFlagModal">Flag this</button>
      EOF
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

    def instance_permitted
      admin? || @instance.user == @user
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

    def flags
      if @flags
        @flags.map{ |f| {
          comment: f.comment,
          added_on: f.added_on,
          user_name: f.user.name,
          user_username: f.user.username
        } }
      end
    end

    def places
      if @instances
        @instances.places.all(:confidence.not => 0).map do |p|
          { lat: p.lat, lon: p.lon, 
            name: p.name, 
            count: count_instances(p),
            slug: p.slug
          } 
        end
      end
    end

    def count_instances(place)
      if @book
        place.instances.select{ |i| i.book_id == @book.id }.count
      else
        place.instances.count
      end
    end

    def not_empty(text)
      case text
      when nil then false
      when "" then false
      else true
      end
    end

    def app_name
      @app_name
    end

  end
end
