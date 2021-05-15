class Api::ArticlesController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :role_authenticator, only: %i[create]

  def index
    articles = Article.all.most_recent
    if current_user&.journalist?
      articles_by_journalist = Article.where(user_id: current_user.id).most_recent
      render json: {}, status: 204 and return if articles_by_journalist == []

      render json: articles_by_journalist, each_serializer: ArticlesIndexSerializer and return
    end
    if articles == []
      render json: {}, status: 204
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
    article = current_user.articles.create(article_params)
    if article.persisted?
      render json: { message: 'Your article has been successfully created!' }, status: 201
    else
      render json: { error_message: 'Please fill in all required fields' }, status: 422
    end
  end

  private

  def method_name; end

  def article_params
    params[:article].permit(:title, :teaser, :body, :category)
  end

  def role_authenticator
    return if current_user.journalist?

    render json: { error_message: 'You are not authorized to create an article' }, status: 403
  end
end
