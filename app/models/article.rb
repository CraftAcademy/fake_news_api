class Article < ApplicationRecord
  validates_inclusion_of :backyard, in: [false, true]
  validates_presence_of :title, :body
  belongs_to :user

  scope :most_recent, -> { order(updated_at: :desc) }
  scope :public_articles, -> { where(backyard: false, published: true) }
  enum status: {arcived: 1, draft: 5, published: 10}

  # Normal articles
  validates :category, :language, :teaser, presence: true, unless: :is_backyard?
  validates :premium, inclusion: { in: [false, true] }, unless: :is_backyard?
  validates :published, inclusion: { in: [false, true] }, unless: :is_backyard?
  validates :category, inclusion: { in: %w[Science Aliens Covid Illuminati Politics Hollywood] }, unless: :is_backyard?
  has_one_attached :image
  has_many :ratings
  has_many :comments

  # Backyard articles
  validates :theme, :location, presence: true, if: :is_backyard?

  def is_backyard?
    backyard
  end
end
