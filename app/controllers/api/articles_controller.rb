class Api::ArticlesController < ApplicationController
  def index
    articles = Article.all().most_recent
    if articles == []
      render json: { articles: articles }, status: 204
    else
      render json: articles, each_serializer: ArticlesIndexSerializer
    end
  end 

  def show
    begin
    article = Article.find(params[:id])
    render json: article, serializer: ArticlesShowSerializer
    rescue ActiveRecord::RecordNotFound => e
      render json: {error_message: 'Article does not exist'}, status: 404
    end
  end 
end
