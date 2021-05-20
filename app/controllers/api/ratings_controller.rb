class Api::RatingsController < ApplicationController
  def create
    rating = Rating.find_by user_id: current_user.id, article_id: params[:article_id]
    article = Article.find(params[:article_id])
    article.ratings.create(rating: params[:rating], user_id: current_user.id)
    render json: { message: 'You successfuly rated this article' }, status: 201
  end
end
