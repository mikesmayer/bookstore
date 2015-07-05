class ChangeAuthorBiographyField < ActiveRecord::Migration
  def change
    change_column :authors, :biography, :text
  end
end
