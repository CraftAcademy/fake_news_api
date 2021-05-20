class AddArticleIdToRating < ActiveRecord::Migration[6.1]
  def change
    add_column :ratings, :article_id, :integer
  end
end
