class Rating < ApplicationRecord
  validates_presence_of :rating, :article_id
  belongs_to :article, -> { where backyard: false }
  belongs_to :user
  validates :rating, inclusion: { in: (1..5).to_a }
end
