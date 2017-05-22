class BaseSerializer
  include JSONAPI::Serializer

  def self_link
    "/api/v1#{super}"
  end
end

class BookSerializer < BaseSerializer
  attributes :slug, :title, :author, :isbn, :year, :url, :cover, :added_on, :modified_on, :total_pages, :instances_per_page, :instance_count

  has_many :instances
  has_many :users

end

class PlaceSerializer < BaseSerializer
  attributes :name, :slug, :confidence, :source, :geonameid, :what3word, :bounding_box_string, :note, :lat, :lon, :added_on, :flagged, :instance_count, :nickname_sentence

  has_many :instances
  has_many :nicknames
  has_one :user

end

class InstanceSerializer < BaseSerializer
  attributes :page, :sequence, :text, :note, :special, :added_on, :modified_on, :flagged, :lat, :lon, :place_name

  has_one :place
  has_one :user
  has_one :book
end

class NicknameSerializer < BaseSerializer
  attributes :name, :instance_count_query, :list_string

  has_one :place
end

class UserSerializer < BaseSerializer
  attributes :name, :username, :admin, :email

  has_many :instances
  has_many :places
end
