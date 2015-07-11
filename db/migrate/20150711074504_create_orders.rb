class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal :total_price
      t.datetime :completed_date
      t.references :billing_address, index: true, foreign_key: true
      t.references :shipping_address, index: true, foreign_key: true
      t.string :status
      t.references :customer, index: true, foreign_key: true
      t.references :credit_card, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
