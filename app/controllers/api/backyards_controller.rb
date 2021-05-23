class Api::BackyardsController < ApplicationController
  def index
    country = get_country()
    backyard_articles = Article.where(location: country).most_recent
    render json: backyard_articles, each_serializer: BackyardsIndexSerializer, root: :backyard_articles
  end

  def show
     backyard_article = Article.find(params[:id])
    render json: backyard_article, serializer: BackyardsShowSerializerSerializer, root: :backyard_article
  end
  

  private

  def get_country
    country_response = Geocoder.search([params[:lat], params[:lon]])
    country_response.first.country
  end
end
