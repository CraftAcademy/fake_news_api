class Article < ApplicationRecord
  validates_presence_of :title, :teaser

  def created_at
    attributes['created_at'].strftime("%F")
  end
end
