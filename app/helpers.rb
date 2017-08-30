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
    
    def json_file
      @json_file
    end

    def flag_modal_button
      <<-EOF
          <button type="button" class="btn btn-danger" data-toggle="modal" data-target="#addFlagModal">Flag this</button>
      EOF
    end

    def add_book_button
      "<a href='/new-book' class='btn btn-primary btn-lg'>Add New Book</a>"
      # "<a href='/new-book' class='btn btn-primary btn-lg disabled'>Add New Book (disabled for demo)</a>"
    end

    def external_link_glyph(link)
      "<a href='#{link}' target='_blank'><span class='fa fa-external-link' aria-hidden='true'></span></a>"
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
            place_names: p.instances_by_names,
            place_names_sentence: p.names_to_sentence,
            slug: p.slug,
            confidence: p.confidence
          } 
        end
      end
    end

    # def place_names_sentence(p)
    #   if @book
    #     @instances.select{ |i| i.place == p }.map{ |i| i.text }.uniq.to_sentence
    #   else
    #     p.nicknames.select{ |n| n.instance_count > 0 }.map{ |n| n.name }.to_sentence
    #   end
    # end

    def get_instances_per_page(book)
      book.total_pages == 0 ? 0 : (book.instances.length.to_f / book.total_pages.to_f).round(2)
    end

    def count_instances(place)
      place.instances_per.count
    end

    # def instances_by_place_names(place)
    #   instances = place.instances_per
    #   # array like [["New York", 41], ["New York City", 6], ["NEW YORK FUCKIN’ CITY", 1]]
    #   place_names = instances.map{|i| i.text}.uniq.map{|n| [n, instances.select{|i| i.text == n}.count]}
    #   string = "<ul style='margin-left: 1em; padding: 0; margin-bottom: 0px;'>"
    #   place_names.each{|name| string = string + "<li>#{name[0]}: #{name[1]}</li>"}
    #   string = string + "</ul>"
    #   string.gsub(/"/, "")
    # end

    # def get_instances_per_place(place)
    #   if @book
    #     place.instances.select{ |i| i.book_id == @book.id }
    #   else
    #     place.instances
    #   end
    # end

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

    def base_url
      @base_url
    end

    def map_height
      "500px;"
    end

  end
end
