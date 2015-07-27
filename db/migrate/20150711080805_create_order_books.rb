class CreateOrderBooks < ActiveRecord::Migration
  def change
    create_table :order_books do |t|
      t.decimal :price
      t.integer :quantity
      t.references :book, index: true
      t.references :order, index: true

      t.timestamps null: false
    end
  end
end
