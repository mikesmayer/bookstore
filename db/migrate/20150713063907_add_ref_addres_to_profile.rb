class AddRefAddresToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :billing_address_id, :integer, index: true
    add_column :profiles, :shipping_address_id, :integer, index: true
  end
end
