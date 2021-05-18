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
end
