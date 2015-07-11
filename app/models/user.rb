class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_one :profile
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :roles
  after_create :create_user_profile, :create_profile_info

  def create_user_profile
    self.create_profile(profile_params)
  end

  def profile_params
    {email: "#{self.email}", password: "#{self.password}"}
  end

  def create_profile_info
    self.profile.create_billing_address
    self.profile.create_shipping_address
    self.profile.create_credit_card

  end


  def role?(role)
    self.roles.find{|i| i.name == role.to_s} != nil
  end

end
