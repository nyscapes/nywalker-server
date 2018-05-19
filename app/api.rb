# frozen_string_literal: true

# This class provides the basic parameters used by the various serializers to
# send data to our clients.

class BaseSerializer
  include JSONAPI::Serializer

  # Provide the namespace
  def self_link
    "/api/v1#{super}"
  end
end

# This class serializes the Book model
class BookSerializer < BaseSerializer
  attributes :slug, :title, :author, :isbn, :year, :url, :cover, :added_on, :modified_on, :total_pages, :instances_per_page, :instance_count

  has_many :instances
  has_many :users

end

# This class serializes the Place model
class PlaceSerializer < BaseSerializer
  attributes :name, :slug, :confidence, :source, :geonameid, :what3word, :bounding_box_string, :note, :lat, :lon, :added_on, :flagged, :instance_count, :nickname_sentence

  has_many :instances
  has_many :nicknames
  has_one :user

end

# This class serializes the Instance model
class InstanceSerializer < BaseSerializer
  attributes :page, :sequence, :text, :note, :special, :added_on, :modified_on, :flagged, :lat, :lon, :place_name

  has_one :place
  has_one :user
  has_one :book
end

# This class serializes the Nickname model
class NicknameSerializer < BaseSerializer
  attributes :name, :instance_count, :list_string #, :instance_count_query

  has_one :place
end

# This class serializes the User model
class UserSerializer < BaseSerializer
  attributes :name, :username, :admin, :email

  has_many :instances
  has_many :places
end
