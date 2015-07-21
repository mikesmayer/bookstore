class Category < ActiveRecord::Base
  has_many  :books, dependent: :destroy
  validates :category_name, presence: true, uniqueness: true

  def self.options_for_select
    order('LOWER(category_name)').map { |e| [e.category_name, e.id] }
  end
end
