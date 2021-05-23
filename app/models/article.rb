class Article < ApplicationRecord
  validates_inclusion_of :backyard, in: [false, true]
  validates_presence_of :title, :teaser, :body, :category
  belongs_to :user
  
  scope :most_recent, -> { order(updated_at: :desc) }

  # Normal articles
  validates :category, :premium, :teaser, presence: true, unless: :is_backyard?
  validates_inclusion_of :premium, in: [false, true], unless: :is_backyard?
  validates :category, inclusion: { in: %w[Science Aliens Covid Illuminati Politics Hollywood] }, unless: :is_backyard?
  has_one_attached :image
  has_many :ratings, -> { where backyard: false }

  # Backyard articles
  validates :theme, :location, presence: true, if: :is_backyard?
  
  def is_backyard?
    self.backyard
  end
end
