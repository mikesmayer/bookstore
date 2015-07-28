class OrderStepsController < ApplicationController
  include Wicked::Wizard

  steps :creating, :shipping, :billing, :paying, :confirmation

  def show
    render_wizard
  end
end
