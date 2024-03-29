class CreateOrderBooks < ActiveRecord::Migration
  def change
    create_table :order_books do |t|
      t.decimal :price
      t.integer :quantity
      t.references :book, index: true, foreign_key: true
      t.references :order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
