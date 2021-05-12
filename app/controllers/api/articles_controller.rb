class Api::ArticlesController < ApplicationController
  def index
    articles = Article.all.sort_by(&:created_at).reverse
    if articles == []
      render json: { articles: articles }, status: 204
    else
      render json: { articles: articles }
    end
  end
end
