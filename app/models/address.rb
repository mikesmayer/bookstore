class Address < ActiveRecord::Base
  has_many :profile
  belongs_to :country
  has_many   :orders
  accepts_nested_attributes_for :country, reject_if: :country_exists?
  validates  :user_address, :city, :zipcode, :phone,  presence: true

  def country_exists?(country_attr)
    if country = Country.find_by_name(country_attr[:name])
      self.country_id = country.id
      true
    end
  end
end
