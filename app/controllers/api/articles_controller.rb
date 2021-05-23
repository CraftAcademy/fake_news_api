class Api::ArticlesController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :role_authenticator, only: %i[create]

  def index
    articles = Article.all.most_recent
    if current_user&.journalist?
      articles_by_journalist = Article.where(user_id: current_user.id).most_recent
      render json: articles_by_journalist, each_serializer: ArticlesIndexSerializer and return
    end
    if params[:category]
      articles_by_category = Article.where(category: params[:category])
      render json: articles_by_category, each_serializer: ArticlesIndexSerializer
    else
      render json: articles, each_serializer: ArticlesIndexSerializer
    end
  end

  def show
    article = Article.find(params[:id])
    render json: article, serializer: ArticlesShowSerializer
  end

  def create
    article = current_user.articles.create(article_params)
    if article.persisted? && attach_image(article)
      render json: { message: 'Your article has been successfully created!' }, status: 201
    else
      render json: { error_message: 'Please fill in all required fields' }, status: 422
    end
  end

  def update
    article = Article.find(params[:id])
    updated_article = article.update(article_params)
    if updated_article
      render json: { message: 'Your article has been successfully updated!' }, status: 200
    else
      render json: { message: 'Article has not been updated' }, status: 422
    end
  end

  private

  def attach_image(article)
    params[:article][:image].present? && DecodeService.attach_image(params[:article][:image], article.image)
  end

  def article_params
    params[:article].permit(:title, :teaser, :body, :category, :premium)
  end

  def role_authenticator
    return if current_user.journalist?

    render json: { error_message: 'You are not authorized to create an article' }, status: 403
  end
end
