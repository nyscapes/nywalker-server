# frozen_string_literal: true
class Place < Sequel::Model
  plugin :validation_helpers

  many_to_one :user
  one_to_many :nicknames
  one_to_many :instances

  def validate
    super
    validates_presence [:name, :slug]
    validates_unique :slug, message: "Place slug is not unique"
  end

  def after_create
    super
    self.added_on = Time.now
  end

  def after_save
    super
    self.modified_on = Time.now
    if Nickname.where(place: self, name: self.name).all.length < 1
      Nickname.create name: self.name, place: self, instance_count: 0
    end
  end

  # For the API
  def instance_count
    self.instances.count
  end

  # For the API
  def nickname_sentence
    self.names_to_sentence
  end

  def instances_per(book = nil)
    if book.nil?
      self.instances
    else
      self.instances.select{ |i| i.book_id == book.id }
    end
  end

  def instances_by_names(book = nil)
    instances = self.instances_per(book)
    # array like [["New York", 41], ["New York City", 6], ["NEW YORK FUCKIN’ CITY", 1]]
    instances.map{|i| i.text}.uniq.map{|n| [n, instances.select{|i| i.text == n}.count]}
  end

  def names_to_sentence(book = nil)
    unless book.nil?
      book.instances.select{ |i| i.place == self }.map{ |i| i.text }.uniq.to_sentence
    else
      self.nicknames.select{ |n| n.instance_count > 0 }.map{ |n| n.name }.to_sentence
    end
  end
  
  # def demolish!
  #   self.nicknames.each{ |n| n.destroy! }
  #   self.destroy!
  # end

  # def merge(oldslug)
  #   oldplace = Place.first slug: oldslug
  #   if oldplace.nil?
  #     puts "Could not find '#{oldslug}'"
  #   else
  #     Instance.all(place: oldplace).each do |instance|
  #       instance.update(place: self)
  #     end
  #     oldplace.demolish!
  #   end
  # end
  
  dataset_module do
    
    def all_with_instances(book = "all", real = true)
      if book == "all"
      q = where(id: Instance.select(:place_id))
      else
      q = where(id: Instance.where(book: book).select(:place_id))
      end
      if real
        q = q.where(confidence:/[123]/)
      end
      q.all
    end

  end

  def before_destroy
    if self.instances.count > 0
      raise "There are instances attached to this place. Cannot delete"
    else
      self.nicknames_dataset.destroy
    end
  end
end
