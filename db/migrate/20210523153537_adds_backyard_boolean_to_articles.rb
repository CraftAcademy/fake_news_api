class AddsBackyardBooleanToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :backyard, :boolean
  end
end
