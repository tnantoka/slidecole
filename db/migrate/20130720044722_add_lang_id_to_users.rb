class AddLangIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lang_id, :integer
    add_index :users, :lang_id
  end
end
