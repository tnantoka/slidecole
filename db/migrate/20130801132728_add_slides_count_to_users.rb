class AddSlidesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slides_count, :integer
  end
end
