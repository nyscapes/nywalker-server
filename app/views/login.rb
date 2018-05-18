# frozen_string_literal: true
class App
  module Views
    class Login < Layout
      include ViewHelpers

      def client_id
        @client_id
      end
    	
    end
  end
end
