class Book < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :author
  belongs_to :category
  has_many   :reviews
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

  def self.to_hash(id)
    book = Book.find(id)
    {id: book.id, title: book.title, price: book.price, quantity: 1}
  end
end
