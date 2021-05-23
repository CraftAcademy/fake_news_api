class Api::BackyardsController < ApplicationController
  def index
    backyard_articles = Article.where(backyard: true)
    render json: {backyard_articles: backyard_articles}
  end
end
