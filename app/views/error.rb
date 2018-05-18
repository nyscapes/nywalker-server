# frozen_string_literal: true
class NYWalkerServer
  module Views
    class Error < Layout

      def error
        @e
      end

      def error_text
        @error_text ? @error_text : ""
      end
    	
    end
  end
end
