class Api::ArticlesController < ApplicationController
  before_action :role_authenticator, only: [:create]

  def index
    articles = Article.all.most_recent
    if articles == []
      render json: { articles: articles }, status: 204
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
    binding.pry
  end

  private

  def role_authenticator
    return if current_user.role == 'journalist'
  end
end
