class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :books
  has_one  :profile
  has_many :review
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :create_user_profile

  def create_user_profile
    self.create_profile(profile_params)
  end

  def profile_params
    {email: "#{self.email}", password: "#{self.password}"}
  end

  def role?(role)
    self.roles.find{|i| i.name == role.to_s} != nil
  end

end
