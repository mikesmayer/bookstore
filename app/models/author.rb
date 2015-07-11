class Author < ActiveRecord::Base
  validates :first_name, :last_name, :biography, presence: true
  validate  :check_full_name_uniq
  has_many  :books

  def check_full_name_uniq
      author_invalid = Author.exists?(:first_name => self.first_name, :last_name => self.last_name)
    if author_invalid
      errors.add(:full_name, "should be uniq")
    end
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

   
end
