class RevertsBodyTypeBackToText < ActiveRecord::Migration[6.1]
  def change
    change_column :articles, :body, :text
  end
end
