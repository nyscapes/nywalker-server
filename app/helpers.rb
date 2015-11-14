class App
  module ViewHelpers

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

    def flash_messages(opts = {})
      if @flash
        @flash.map do |type, message| 
          { flash_class: bootstrap_class_for(type), flash_message: message }
        end
      end
    end

    def bootstrap_class_for flash_type
      { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
    end
  end
end
