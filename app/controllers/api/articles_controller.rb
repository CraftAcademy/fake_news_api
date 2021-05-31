class Api::ArticlesController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :admin_authenticator, only: %i[create]
  before_action :set_language_for_index, only: %i[index]

  def index
    if current_user&.editor?
      articles = Article.where(backyard: false).most_recent
      render json: articles, each_serializer: ArticlesIndexSerializer and return
    elsif current_user&.journalist?
      articles_by_journalist = Article.where(user_id: current_user.id, backyard: false).most_recent
      render json: articles_by_journalist, each_serializer: ArticlesIndexSerializer and return
    end
    if params[:category]
      articles_by_category = Article.public_articles.where(category: params[:category], language: @language)
      render json: articles_by_category, each_serializer: ArticlesIndexSerializer
    else
      articles = Article.public_articles.most_recent.where(language: @language)
      render json: articles, each_serializer: ArticlesIndexSerializer
    end
  end

  def show
    article = Article.find(params[:id])
    if request.headers[:source] == 'admin-system'
      if article_evaluation(article)
        render json: article, serializer: ArticlesShowSerializer
      else
        render json: { error_message: 'You are not authorized to see this article' }, status: 403
      end
    elsif article.published?
      render json: article, serializer: ArticlesShowSerializer
    else
      render json: { error_message: 'This article does not exist' }, status: 404
    end
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
    if article_evaluation(article)
      if params[:status]
        update_article_status(article, params[:status])
      else
        update_article(article)
      end
    else
      render json: { error_message: 'You are not authorized to edit this article' }, status: 403
    end
  end

  private

  def set_language_for_index
    @language = if params[:language]
                  params[:language].upcase
                else
                  'EN'
                end
  end

  def attach_image(article)
    params[:article][:image].present? && DecodeService.attach_image(params[:article][:image], article.image)
  end

  def article_params
    params[:article].permit(:title, :teaser, :category, :status, :premium, :body, :language)
  end

  def article_evaluation(article)
    (current_user&.journalist? && article.user_id == current_user.id) || current_user&.editor?
  end

  def admin_authenticator
    return if current_user.journalist?

    render json: { error_message: 'You are not authorized to create an article' }, status: 403
  end

  def update_article_status(article, status)
    if current_user.editor?
      article.update(status: status)
      render json: { message: 'Your article has been successfully updated!' }, status: 200
    else
      render json: { error_message: 'You are not authorized to publish an article!' }, status: 403
    end
  end

  def update_article(article)
    updated_article = article.update(article_params)
    if updated_article
      render json: { message: 'Your article has been successfully updated!' }, status: 200
    else
      render json: { message: 'Article has not been updated' }, status: 422
    end
  end
end
