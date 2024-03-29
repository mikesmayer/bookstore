class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :email
      t.string :password
      t.string :first_name
      t.string :last_name
      t.references :credit_card, index: true
      t.references :address, index: true

      t.timestamps null: false
    end
  end
end
