class Api::ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    articles = Article.all.most_recent
    if articles == []
      render json: { articles: articles }, status: 204
    elsif params[:category]
      articles_by_category = Article.where(category: params[:category])
      if articles_by_category == []
        render json: { error_message: 'There is no Articles in this category' }, status: 404
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
    render json: { error_message: 'Article does not exist' }, status: 404
  end

  def create
    unless current_user.journalist? 
      render json: { error_message: 'You are not authorized to create an article' },
             status: 403 and return
    end

    article = current_user.articles.create(article_params)
    if article.persisted? && attach_image(article)
      render json: { message: 'Your article has been successfully created!' }, status: 201
    else
      render json: { error_message: 'Please fill in all required fields' }, status: 422
    end
  end

  private

  def attach_image(article)
    params[:article][:image].present? && DecodeService.attach_image(params[:article][:image].first, article)
  end

  def article_params
    params[:article].permit(:title, :teaser, :body, :category, keys: [:images])
  end
end
