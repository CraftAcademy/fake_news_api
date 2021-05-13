class AddBodyToArticle < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :body, :text
  end
end
