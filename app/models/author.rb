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

  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
      :search_query
    ]
  )

   scope :search_query, lambda { |query|
   
  }
end
