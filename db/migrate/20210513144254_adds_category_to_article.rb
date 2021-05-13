class AddsCategoryToArticle < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :category, :string
  end
end
