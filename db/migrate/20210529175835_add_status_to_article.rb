class AddStatusToArticle < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :status, :integer, default: 5
  end
end
