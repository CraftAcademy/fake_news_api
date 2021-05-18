class ArticlesIndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :teaser, :date, :category, :image

  def date
    object.created_at.strftime('%F, %H:%M')
  end
end
