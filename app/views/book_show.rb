# frozen_string_literal: true
class NYWalkerServer
  module Views

    class BookShow < Layout
      include ViewHelpers

      def external_link
        external_link_glyph(@book.url)
      end

      def last_updated
        unless @last_updated.nil?
          if @last_updated < 11
            "; list updated #{@last_updated} minutes ago"
          else
            ""
          end
        end
      end

      def id
        @book.id
      end

      def author
        @book.author
      end

      def title
        @book.title
      end

      def year
        @book.year
      end

      def isbn
        @book.isbn
      end

      def cover
        @book.cover
      end

      def special_field
        @book.special.field unless @book.special.nil?
      end

      def cover_alt
        "#{title}, #{year}"
      end

      def link
        @book.url
      end

      def slug
        @book.slug
      end

      def instances
        @instances.map do |i| 
          {
            page: i[:page], 
            sequence: i[:sequence], 
            place_name: i[:place_name], 
            place_slug: i[:place_slug], 
            instance_id: i[:id],
            owner: i[:owner],
            flagged: i[:flagged],
            text: i[:text],
            special: i[:special],
            note: not_empty(i[:note]),
            instance_permitted: ( admin? || Instance[i[:id]].user == @user )
          } 
        end
      end

      def instance_count
        @instances.length
      end

      def instances_per_page
        get_instances_per_page(@book.total_pages, instance_count)
      end

      def map_height
        "300px;"
      end

    end
  end
end
