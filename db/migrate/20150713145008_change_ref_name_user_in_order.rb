class ChangeRefNameUserInOrder < ActiveRecord::Migration
   def change
     remove_column :orders, :customer_id, :integer, index: true
     add_column    :orders, :user_id,     :integer, index: true
   end
end
