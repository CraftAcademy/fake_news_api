class AddUserIdToRating < ActiveRecord::Migration[6.1]
  def change
    add_column :ratings, :user_id, :integer
  end
end
