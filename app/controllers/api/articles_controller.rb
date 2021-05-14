class Api::ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    articles = Article.all.most_recent
    if articles == []
      render json: { articles: articles }, status: 204
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

  def create
    unless current_user.role == "journalist"
      render json: { error_message: "You dont have access" }, status: 403 and return
    end

    article = current_user.articles.create(params[:article].permit(:title, :teaser, :body))
    if article.persisted?
      render json: { message: "Your article has been successfully created!" }, status: 201
    else
      render json: { error_message: "Please fill in all required fields" }, status: 422
    end
  end
end
