class Flag < Sequel::Model
  plugin :validation_helpers

  many_to_one :user

  def validate
    super
    validates_presence [:object_type, :object_id]
  end
end
