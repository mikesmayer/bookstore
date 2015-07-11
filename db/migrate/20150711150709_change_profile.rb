class ChangeProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :address_id
    add_column    :profiles, :billing_address_id, :integer, index: true
    add_column    :profiles, :shipping_address_id,:integer, index: true
  end
end
