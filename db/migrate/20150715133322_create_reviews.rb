class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :text
      t.references :user, index: true
      t.references :book, index: true

      t.timestamps null: false
    end
  end
end
