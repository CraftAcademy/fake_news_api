class Api::RatingsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  
  def create
    article = Article.find(params[:article_id])
    rating = Rating.find_by(user_id: current_user.id, article_id: params[:article_id])
    if rating
      rating.update(rating_params())
    else
      article.ratings.create(rating_params())      
    end
    render_success()
  end

  private

  def rating_params
    return { rating: params[:rating], user_id: current_user.id }
  end

  def render_success
    render json: { message: 'You successfuly rated this article' }, status: 200
  end
end
