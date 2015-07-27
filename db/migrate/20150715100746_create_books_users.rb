class CreateBooksUsers < ActiveRecord::Migration
  def change
    create_table :books_users, id: false do |t|
      t.references :book, index: true
      t.references :user, index: true
    end
  end
end
