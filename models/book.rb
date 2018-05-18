# frozen_string_literal: true
class Book < Sequel::Model
# frozen_string_literal: true
  plugin :validation_helpers
# frozen_string_literal: true

# frozen_string_literal: true
  one_to_one :special
# frozen_string_literal: true
  one_to_many :instances
# frozen_string_literal: true
  many_to_many :users, left_key: :book_id, right_key: :user_id, join_table: :book_users
# frozen_string_literal: true

# frozen_string_literal: true
  def validate
# frozen_string_literal: true
    super
# frozen_string_literal: true
    validates_presence [:author, :title, :slug]
# frozen_string_literal: true
    validates_unique :slug, message: "Book slug is not unique"
# frozen_string_literal: true
  end
# frozen_string_literal: true

# frozen_string_literal: true
  def after_create
# frozen_string_literal: true
    self.added_on = Time.now
# frozen_string_literal: true
  end
# frozen_string_literal: true

# frozen_string_literal: true
  def after_save
# frozen_string_literal: true
    self.modified_on = Time.now
# frozen_string_literal: true
  end
# frozen_string_literal: true

# frozen_string_literal: true
  def total_pages
# frozen_string_literal: true
    instances = Instance.where(book: self).map(:page).sort
# frozen_string_literal: true
    instances.length == 0 ? 0 : instances.last - instances.first
# frozen_string_literal: true
  end
# frozen_string_literal: true

# frozen_string_literal: true
  def instances_per_page
# frozen_string_literal: true
    if self.total_pages == 0
# frozen_string_literal: true
      "∞"
# frozen_string_literal: true
    else
# frozen_string_literal: true
      (self.instances.count.to_f / self.total_pages.to_f).round(2)
# frozen_string_literal: true
    end
# frozen_string_literal: true
  end
# frozen_string_literal: true

# frozen_string_literal: true
  def instance_count
# frozen_string_literal: true
    self.instances.count
# frozen_string_literal: true
  end
# frozen_string_literal: true

# frozen_string_literal: true
  def last_instance
# frozen_string_literal: true
    Instance.last_instance_for_book(self)
# frozen_string_literal: true
  end
# frozen_string_literal: true

# frozen_string_literal: true
  def user_sentence
# frozen_string_literal: true
    self.users.map{|u| u.fullname}.to_sentence
# frozen_string_literal: true
  end
# frozen_string_literal: true

# frozen_string_literal: true
  dataset_module do
# frozen_string_literal: true

# frozen_string_literal: true
    def all_with_instances_sorted
# frozen_string_literal: true
      where(id: Instance.select(self))
# frozen_string_literal: true
        .order(:title)
# frozen_string_literal: true
        .all
# frozen_string_literal: true
    end
# frozen_string_literal: true

# frozen_string_literal: true
  end
# frozen_string_literal: true
end
