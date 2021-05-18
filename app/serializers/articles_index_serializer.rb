class ArticlesIndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :teaser, :date, :category, :image

  def date
    object.created_at.strftime('%F, %H:%M')
  end

  # def image
  #   object.image.service_url(expires_in: 1.hour, disposition: 'inline')
  # end
end
