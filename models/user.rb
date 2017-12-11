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

  def fullname
    if self.lastname.nil? && self.firstname
      self.firstname
    elsif self.firstname.nil? && self.lastname
      self.lastname
    elsif self.firstname.nil? && self.lastname.nil?
      self.name
    else
      "#{self.firstname} #{self.lastname}"
    end
  end

  def fullname_lastname_first
    if self.lastname.nil? && self.firstname
      self.firstname
    elsif self.firstname.nil? && self.lastname
      self.lastname
    elsif self.firstname.nil? && self.lastname.nil?
      self.name
    else
      "#{self.lastname}, #{self.firstname}"
    end
  end
end

