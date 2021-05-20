class Api::RatingsController < ApplicationController
  def create
    article = Article.find(params[:article_id])
    rating = Rating.find_by user_id: current_user.id, article_id: params[:article_id]
    if !rating      
      article.ratings.create(rating: params[:rating], user_id: current_user.id)
      render json: { message: 'You successfuly rated this article' }, status: 200
    else
      article.ratings.update(rating: params[:rating], user_id: current_user.id)
      render json: { message: 'You successfuly rated this article' }, status: 200
    end    
  end
end
