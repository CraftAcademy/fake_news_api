class Api::BackyardsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :editor_authenticator, only: %i[update]
  before_action :editor_index_action, only: %i[index]

  def index
    country = get_country
    backyard_articles = Article.where(location: country).most_recent
    render json: backyard_articles, each_serializer: BackyardsIndexSerializer, root: :backyard_articles,
           meta: country, meta_key: :location
  end

  def show
    backyard_article = Article.find(params[:id])
    render json: backyard_article, serializer: BackyardsShowSerializerSerializer, root: :backyard_article
  end

  def create
    backyard_article = build_backyard_article
    if backyard_article.persisted?
      render json: { message: 'Your backyard article has been successfully created!' }, status: 201
    else
      render json: { error_message: 'Please fill in all required fields' }, status: 422
    end
  end

  def update
    backyard_article = Article.find(params[:id])
    archive_article(backyard_article)   
  end

  private

  def archive_article(backyard_article)
    backyard_article.archived!
    backyard_article.save
    render json: { message: 'This backyard article has been successfully archived' }, status: 200
  end

  def get_country
    country_response = Geocoder.search([params[:lat], params[:lon]])
    country_response.first.country
  end

  def article_params
    params[:backyardArticle].permit(:title, :theme, :location, :body)
  end

  def build_backyard_article
    backyard_article = current_user.articles.build(article_params)
    backyard_article['backyard'] = true
    backyard_article['status'] = 'published'
    backyard_article.save
    backyard_article
  end

  def editor_authenticator
    return if current_user&.editor?

    render json: { error_message: 'You are not authorized to archive this article' }, status: 403
  end

  def editor_index_action
    render json: Article.where(backyard: true), each_serializer: BackyardsIndexSerializer if current_user&.editor?
    nil
  end
end
