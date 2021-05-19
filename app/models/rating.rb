class Rating < ApplicationRecord
  validates_presence_of :rating, :article_id
  belongs_to :article
  validates :rating, inclusion: { in: (1..5).to_a }
end
