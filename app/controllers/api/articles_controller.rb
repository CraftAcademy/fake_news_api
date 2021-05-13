class Api::ArticlesController < ApplicationController
  def index
    articles = Article.all.most_recent
    if articles == []
      render json: { articles: articles }, status: 204
    elsif params[:category]
      articles_by_category = Article.where(category: params[:category])
      if articles_by_category == []
        render json: { error_message: "There is no Articles in this category" }, status: 404
      else
        render json: articles_by_category, each_serializer: ArticlesIndexSerializer
      end
    else
      render json: articles, each_serializer: ArticlesIndexSerializer
    end
  end

  def show
    article = Article.find(params[:id])

    render json: article, serializer: ArticlesShowSerializer
  rescue ActiveRecord::RecordNotFound => e
    render json: { error_message: "Article does not exist" }, status: 404
  end
end
