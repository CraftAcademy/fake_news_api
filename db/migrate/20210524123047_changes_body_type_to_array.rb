class ChangesBodyTypeToArray < ActiveRecord::Migration[6.1]
  def change
    change_column :articles, :body, :text, array: true, using: 'body::text[]'
  end
end
