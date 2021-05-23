class AddsLocationThemeAndWrittenByToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :location, :string
    add_column :articles, :theme, :string
  end
end
