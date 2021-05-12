class Api::ArticlesController < ApplicationController
  def index
    articles = Article.all().sort_by(&:created_at).reverse()
    render json: { articles: articles }
  end
end
