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

  
########### Edit after
  filterrific(
    available_filters: [
      :search_query
    ]
  )


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
    num_or_conditions = 2
    where(
      terms.map {
        or_clauses = [
          "LOWER(authors.first_name) LIKE ?",
          "LOWER(authors.last_name) LIKE ?",
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  }
end
