class User < Sequel::Model
  plugin :validation_helpers
  plugin :secure_password

  one_to_many :instances
  many_to_many :books, left_key: :book_id, right_key: :user_id, join_table: :book_users
  one_to_many :places
  one_to_many :flags

  def validate
    super
    validates_presence [:username, :email]
    validates_unique [:email]
  end

  def has_key?(key)
    true
  end

  def admin?
    self.admin
  end
end

