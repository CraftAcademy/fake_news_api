class AddStatusToArticle < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :status, :integer
  end
end
