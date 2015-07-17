class ChangeProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :address_id, :integer
  end
end
