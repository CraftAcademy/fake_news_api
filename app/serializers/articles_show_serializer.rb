class ArticlesShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :date, :author, :category

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
