class ArticlesShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :date, :author

  def author
    {
      first_name: object.user.first_name,
      last_name: object.user.last_name
    }
  end

  def date
    object.created_at.localtime.strftime('%F, %H:%M')
  end
end
