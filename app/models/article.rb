class Article < ApplicationRecord
  validates_presence_of :title, :teaser, :body
  scope :most_recent, -> { order(created_at: :desc)}
  belongs_to :user
end
