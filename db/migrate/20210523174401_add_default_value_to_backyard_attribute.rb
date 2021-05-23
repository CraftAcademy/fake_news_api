class AddDefaultValueToBackyardAttribute < ActiveRecord::Migration[6.1]
  def change
    change_column :articles, :backyard, :boolean, :default => false
  end
end
