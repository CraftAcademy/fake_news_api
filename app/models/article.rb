class Article < ApplicationRecord
  validates_presence_of :title, :teaser, :body, :category
  scope :most_recent, -> { order(created_at: :desc) }
  belongs_to :user
  validates :category, inclusion: { in: %w[Science Aliens Covid Illuminati Politics Hollywood] }
  has_one_attached :image
end
