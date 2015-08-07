class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.string :name
      t.float :price

      t.timestamps null: false
    end

    create_table :deliveries_orders, id: false do |t|
      t.belongs_to :order,    index: true
      t.belongs_to :delivery, index: true
    end

    add_column :orders, :delivery_id, :integer
  end
end
