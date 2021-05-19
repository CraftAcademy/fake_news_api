class ArticlesShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :teaser, :body, :date, :author, :category, :image

  def author
    {
      first_name: object.user.first_name,
      last_name: object.user.last_name
    }
  end

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
