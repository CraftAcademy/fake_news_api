class ArticlesIndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :teaser, :date, :category, :image, :rating

  def date
    object.created_at.strftime('%F, %H:%M')
  end

  def image
    if Rails.env.test?
      object.image
    else
      object.image.url(expires_in: 1.hour, disposition: 'inline')
    end
  end

  def rating
    Rating.where(article_id: object.id).average(:rating).to_f
  end
end
