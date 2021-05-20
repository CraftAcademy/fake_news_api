class AddRatingToRating < ActiveRecord::Migration[6.1]
  def change
    add_column :ratings, :rating, :integer
  end
end
