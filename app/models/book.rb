# frozen_string_literal: true
class Book < Sequel::Model
  plugin :validation_helpers

  one_to_one :special
  one_to_many :instances
  many_to_many :users, left_key: :book_id, right_key: :user_id, join_table: :book_users

  def before_validation
    super
    create_slug
  end

  def validate
    super
    validates_presence [:author, :title, :slug, :year]
    validates_unique :slug, message: "Book slug is not unique"
  end

  def after_create
    self.added_on = Time.now
  end

  def after_save
    self.modified_on = Time.now
  end

  def name
    "#{self.title} (#{self.year})"
  end

  def total_pages
    instances = Instance.where(book: self).map(:page).sort
    instances.length == 0 ? 0 : instances.last - instances.first
  end

  def instances_per_page
    if self.total_pages == 0
      "∞"
    else
      (self.instances.count.to_f / self.total_pages.to_f).round(2)
    end
  end

  def instance_count
    self.instances.count
  end

  def special_field
    if self&.speciali&.field
      self.special.field
    end
  end

  def special_help_text
    if self&.special&.help_text
      self.special.help_text
    end
  end

  def all_places
    Instance.all_placeids_with_counts(self).map do |group_member|
      place = Place[group_member.place_id]
      { id: place.id,
        slug: place.slug,
        lat: place.lat,
        lon: place.lon,
        count: group_member.values[:count],
        name: place.name,
        confidence: place.confidence,
        # names_to_sentence: place.names_to_sentence(self),
        instance_count_by_name: place.instances_by_names(self)
      } 
    end
  end

  def mappable_places
    self.all_places.select{|p| p[:confidence] =~ /^[123]{1}$/}
  end

  def unmappable_places
    self.all_places.select{|p| p[:confidence] =~ /^0$/}
  end

  def last_instance
    if Instance.last_instance_for_book(self).nil?
      nil
    else
      Instance.last_instance_for_book(self).id
    end
  end

  def user_sentence
    self.users.map{|u| u.fullname}.to_sentence
  end

  dataset_module do

    def all_with_instances_sorted
      where(id: Instance.select(self))
        .order(:title)
        .all
    end

  end
end
