class ArticlesIndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :teaser, :date

  def date
    object.created_at.strftime('%F')
  end
end
