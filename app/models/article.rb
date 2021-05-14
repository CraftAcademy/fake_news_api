class Article < ApplicationRecord
  validates_presence_of :title, :teaser, :body, :category
  scope :most_recent, -> { order(created_at: :desc)}
  belongs_to :user
  validates :category, inclusion: { in: ['Flat Earth', 'Aliens', 'Covid', 'Illuminati', 'Politics', 'Hollywood']}
end
