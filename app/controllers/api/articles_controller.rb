class Api::ArticlesController < ApplicationController
  def index
    articles = Article.all()
    articles.each_with_index do |article,index| 
      articles[index].created_at = article.created_at.strftime("%F")
      # article['created_at'] = article['created_at'].strftime('%F')
    end
   binding.pry
    render json: { articles: articles }
  end
end
