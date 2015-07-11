class Category < ActiveRecord::Base
  validates :category_name, presence: true, uniqueness: true

  def self.options_for_select
    order('LOWER(category_name)').map { |e| [e.category_name, e.id] }
  end
end
