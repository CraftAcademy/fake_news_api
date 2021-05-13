class ArticlesIndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :teaser, :date, :category

  def date
    object.created_at.localtime.strftime('%F, %H:%M')
  end
end
