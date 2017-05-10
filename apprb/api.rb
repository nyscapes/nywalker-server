class BaseSerializer
  include JSONAPI::Serializer

  def self_link
    "/api/v1#{super}"
  end
end

class PlaceSerializer < BaseSerializer
  attributes :name, :slug, :confidence, :source, :geonameid, :what3word, :bounding_box_string, :note, :lat, :lon, :added_on, :flagged

  has_many :instances
  has_many :nicknames

end

class InstanceSerializer < BaseSerializer
  attributes :page, :sequence, :text, :note, :special, :added_on, :modified_on, :flagged

  has_one :place
end

class NicknameSerializer < BaseSerializer
  attributes :name, :instance_count

  has_one :place
end
