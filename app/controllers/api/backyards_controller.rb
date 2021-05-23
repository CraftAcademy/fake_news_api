class Api::BackyardsController < ApplicationController
  def index
    country = get_country()
    backyard_articles = Article.where(location: country).most_recent
    render json: backyard_articles, each_serializer: BackyardsIndexSerializer, root: :backyard_articles, 
                meta: country, meta_key: :location
  end

  private

  def get_country
    country_response = Geocoder.search([params[:lat], params[:lon]])
    country_response.first.country
  end
end
