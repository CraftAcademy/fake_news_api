class Api::BackyardsController < ApplicationController
  def index
    country = get_country()
    backyard_articles = Article.where(backyard: true, location: country).most_recent
    render json: backyard_articles, each_serializer: BackyardsIndexSerializer, root: :backyard_articles
  end

  private

  def get_country
    country_response = Geocoder.search([params[:lat], params[:lon]])
    country_response.first.country
  end
end
