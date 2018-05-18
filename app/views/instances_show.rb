# frozen_string_literal: true
class NYWalkerServer
  module Views

    class InstancesShow < Layout
      include ViewHelpers

      def special_field
        "Special"
      end

      def instances
        @instances.map{ |i| {
          page: i.page, sequence: i.sequence, place_name: i.place.name, place_slug: i.place.slug, instance_id: i.id,
          instance_permitted: ( admin? || i.user == @user ),
          owner: i.user.name,
          flagged: i.flagged,
          note: not_empty(i.note),
          special: i.special,
          slug: i.book.slug
        } }
      end

    end
  end
end
