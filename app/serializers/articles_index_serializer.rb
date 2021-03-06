class ArticlesIndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :teaser, :date, :category, :status, :language, :image, :rating, :author, :premium, :comments

  def date
    object.updated_at.strftime('%F, %H:%M')
  end

  def status
    object.status.capitalize    
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

  def author
    {
      first_name: object.user.first_name,
      last_name: object.user.last_name
    }
  end

  def comments
    object.comments.count
  end
end
