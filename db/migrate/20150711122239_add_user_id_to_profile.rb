class AddUserIdToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :user_id, :integer, index: true
  end
end
