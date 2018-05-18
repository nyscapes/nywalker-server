# frozen_string_literal: true
class NYWalkerServer
  module Views

    class InstanceNew < Layout

      def form_button
        "Add Instance"
      end

      def page
        @last_instance.nil? ? 1 : @last_instance.page
      end

      def sequence
        @last_instance.nil? ? 1 : @last_instance.sequence + 1
      end

      def special
        @last_instance.nil? ? nil : @last_instance.special
      end

      def book_title
        @book.title
      end

      def book_slug
        @book.slug
      end

      def special_field
        @book.special.field unless @book.special.nil?
      end

      def special_help_text
        @book.special.help_text unless @book.special.nil?
      end

      def nicknames
        @nicknames
      end

      def form_source
        "modal"
      end

      def last_instance
        { li_page: @last_instance.page,
          li_sequence: @last_instance.sequence,
          li_place: @last_instance.place.name,
          li_place_name_in_text: @last_instance.text,
          li_place_slug: @last_instance.place.slug,
          li_owner: @last_instance.user.name,
          li_note: @last_instance.note,
          li_special: @last_instance.special,
          li_id: @last_instance.id } unless @last_instance.nil?
      end

      def edit_last_instance
        @user.admin? || @last_instance.user == @user
      end

      def object_id_for_flag
        @last_instance.id unless @last_instance.nil?
      end

      def type
        "instance"
      end

    end
  end
end
