# frozen_string_literal: true
class Special < Sequel::Model
  plugin :validation_helpers

  one_to_one :book

  def validate
    super
    validates_presence [:field]
  end
end
