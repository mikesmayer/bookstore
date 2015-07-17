class ChangeReferenceToProfilInCreditCard < ActiveRecord::Migration
  def change
    rename_column :credit_cards, :user_id, :profile_id
  end
end
