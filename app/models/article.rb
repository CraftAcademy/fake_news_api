class Article < ApplicationRecord
  validates_presence_of :title, :teaser, :body, :category
  validates_inclusion_of :premium, in: [false, true]
  scope :most_recent, -> { order(updated_at: :desc) }
  belongs_to :user
  has_many :ratings
  validates :category, inclusion: { in: %w[Science Aliens Covid Illuminati Politics Hollywood] }
  has_one_attached :image
end
