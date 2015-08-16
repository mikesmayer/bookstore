class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :books
  has_many :credit_cards
  has_one  :profile
  has_many :orders
  has_many :review
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]
  after_create :create_user_profile, :set_role
  attr_accessor :session

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid      = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def set_role
    Role.create(name: "customer") if Role.find_by(name: "customer").nil?
    self.roles << Role.find_by(name: "customer")
  end

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
