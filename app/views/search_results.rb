class App
  module Views

    class SearchResults < Naked

      def results_table
        ! @results.nil?
      end

      def results
        @results.map{ |r| { name: r[:name], lat: r[:lat], lon: r[:lon], description: r[:description] } }
      end

      def search_term
        @search_term
      end

    end
  end
end
