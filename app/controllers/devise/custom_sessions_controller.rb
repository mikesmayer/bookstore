class Devise::CustomSessionsController  < Devise::SessionsController
  include TempOrder
  before_action :temp_order, only: :create
  after_action  :find_session_order, only: :create
end
