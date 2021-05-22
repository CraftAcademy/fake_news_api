class AddPremiumToArticle < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :premium, :boolean, default: false
  end
end
