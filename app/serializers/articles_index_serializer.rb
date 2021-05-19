class ArticlesIndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :teaser, :date, :category, :image

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
end
