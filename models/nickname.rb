class Nickname < Sequel::Model
  plugin :validation_helpers

  many_to_one :place

  def validate
    super
    validates_presence [:name, :instance_count]
  end

  # def instance_count_query
  #   Instance.all(place: self.place, text: self.name).count
  # end

  def list_string
    "#{self.name} -- {#{self.place.name}}"
  end

  dataset_module do
    def sorted_by_instance_count
      order(:instance_count)
        .all
        .reverse
    end
  end
end
