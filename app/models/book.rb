class Book < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :author
  belongs_to :category
  has_many   :reviews
  has_many   :order_books, dependent: :destroy
  has_many   :orders, through: :order_books
  validates  :title, :description, :quantity, :price, 
             :category_id, :author_id, presence: true
  validates  :price, numericality: {greater_than: 0}

  mount_uploader :cover, CoverUploader

 filterrific :available_filters => %w[
                search_query
                with_category_id
              ]

  self.per_page = 12

  scope :search_query, lambda { |query|
    return nil  if query.blank?
    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 3
    where(
      terms.map {
        or_clauses = [
          "LOWER(books.title) LIKE ?",
          "LOWER(authors.first_name) LIKE ?",
          "LOWER(authors.last_name) LIKE ?",

        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    ).joins(:author).references(:author)
  }

  scope :with_category_id, lambda { |category_ids|
    where(:category_id => [*category_ids])
  }

  def book_in_stock(quantity)
    if self.quantity < quantity
      errors.add(:book_quantity_error, "Only #{self.quantity} books '#{self.title}' are available")
      return false
    else
      return true
    end
  end

  def in_wishlist?(current_user)
    current_user.books.include?(self)
  end

  def update_book(operation, by_quantity)
    if operation == :reduce 
      new_quantity = self.quantity - by_quantity
    elsif operation == :increase 
      new_quantity = self.quantity + by_quantity
    end
    self.update(quantity: new_quantity)
  end
end
