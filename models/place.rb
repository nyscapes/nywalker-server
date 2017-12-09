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

  def instances_per
    if @book
      self.instances.select{ |i| i.book_id == @book.id }
    else
      self.instances
    end
  end

  def instances_by_names
    instances = self.instances_per
    # array like [["New York", 41], ["New York City", 6], ["NEW YORK FUCKIN’ CITY", 1]]
    place_names = instances.map{|i| i.text}.uniq.map{|n| [n, instances.select{|i| i.text == n}.count]}
    string = "<ul style='margin-left: 1em; padding: 0; margin-bottom: 0px;'>"
    place_names.each{|name| string = string + "<li>#{name[0]}: #{name[1]}</li>"}
    string = string + "</ul>"
    string.gsub(/"/, "")
  end

  def names_to_sentence
    if @book
      @book.instances.select{ |i| i.place == self }.map{ |i| i.text }.uniq.to_sentence
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
    if self.instances.count != 0
      raise "There are instances attached to this place. Cannot delete"
    else
      self.nicknames_dataset.destroy
    end
  end
end
