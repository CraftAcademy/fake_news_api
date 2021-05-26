class StatisticsIndexSerializer < ActiveModel::Serializer
  attributes :id, :articles, :backyard_articles, :journalists, :subscribers

  def articles
    { total: Article.where(backyard: false).count,
      published: Article.where(published: true, backyard: false).count,
      unpublished: Article.where(published: false, backyard: false).count }
  end

  def backyard_articles
    { total: Article.where(backyard: true).count }
  end

  def journalists
    { total: User.where(role: 5).count }
  end

  def subscribers
    { total: User.where(role: 2).count }
  end
end
