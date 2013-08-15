class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :content
      t.string :kind
      t.integer :order
      t.references :slide, index: true

      t.timestamps
    end
  end
end
