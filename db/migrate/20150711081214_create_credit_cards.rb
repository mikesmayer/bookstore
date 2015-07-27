class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.string :number
      t.string :cvv
      t.integer :expiration_month
      t.integer :expiration_year
      t.string :first_name
      t.string :last_name
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
