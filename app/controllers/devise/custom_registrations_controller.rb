class Devise::CustomRegistrationsController  < Devise::RegistrationsController
  include TempOrder
  before_action :temp_order, only: :create
  after_action  :find_session_order, only: :create
end
