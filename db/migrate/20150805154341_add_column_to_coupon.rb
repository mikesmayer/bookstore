class AddColumnToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :sale, :float
  end
end
