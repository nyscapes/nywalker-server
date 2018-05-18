# frozen_string_literal: true
class NYWalkerServer
  module Views

    class SearchResults < Naked

      def results_table
        ! @results.nil?
      end

      def results
        @results.map{ |r| { name: r[:name], lat: r[:lat], lon: r[:lon], description: r[:description], geonameid: r[:geonameid], bbox: r[:bbox], escaped_name: r[:name].gsub(/'/, "’") } }
      end

      def search_term
        @search_term
      end

      def first_lat
        @results[0][:lat]
      end

      def first_lon
        @results[0][:lon]
      end

    end
  end
end
