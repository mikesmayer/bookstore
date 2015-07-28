class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :user_address
      t.string :zipcode
      t.string :city
      t.string :phone
      t.references :country, index: true

      t.timestamps null: false
    end
    
    add_foreign_key :orders, :addresses, column: :billing_address_id
    add_foreign_key :orders, :addresses, column: :shipping_address_id
  end
end
