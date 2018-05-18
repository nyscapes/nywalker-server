# frozen_string_literal: true
class App
  module ViewHelpers

    def admin
      @admin
    end

    def stylesheets
      @css
    end

    def metadata
      @metadata
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

    # def user_sentence(userlist)
    #   list = userlist.map do |user|
    #     user.name
    #   end
    #   list.to_sentence
    # end

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
      if @places
        @places.map do |p|
          { lat: p.lat, lon: p.lon, 
            name: p.name, 
            count: count_instances(p, @book),
            place_names: instances_by_names(p, @book),
            place_names_sentence: p.names_to_sentence(@book),
            slug: p.slug,
            confidence: p.confidence
          } 
        end
      end
    end

    def get_instances_per_page(total_pages, instances)
      total_pages == 0 ? 0 : (instances.to_f / total_pages.to_f).round(2)
    end

    def count_instances(place, book)
      place.instances_per.count(book)
    end

    def instances_by_names(place, book)
      string = "<ul style='margin-left: 1em; padding: 0; margin-bottom: 0px;'>"
      place.instances_by_names(book).each do |name|
        string = string + "<li>#{name[0]}: #{name[1]}</li>"
      end
      string = string + "</ul>"
      string.gsub(/"/, "")
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

    def base_url
      @base_url
    end

    def map_height
      "500px;"
    end

  end
end
