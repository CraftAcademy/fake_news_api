class Api::ArticlesController < ApplicationController
  def index
    articles = Article.all()
    render json: {articles: articles}
  end
end
