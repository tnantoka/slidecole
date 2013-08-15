class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.string :title
      t.string :slug
      t.boolean :is_draft, default: false
      t.references :category, index: true
      t.references :lang, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
