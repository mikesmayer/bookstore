class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.text :review
      t.integer :rating
      t.references :book, index: true
      t.references :customer, index: true

      t.timestamps null: false
    end
  end
end
