class AddImpressionsCountToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :impressions_count, :integer, default: 0
  end
end
