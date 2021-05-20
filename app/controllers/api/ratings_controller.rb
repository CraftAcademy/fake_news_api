class Api::RatingsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]

  def create
    article = Article.find(params[:article_id])
    rating = Rating.find_by(user_id: current_user.id, article_id: params[:article_id])
    if rating
      rating.update(rating_params)
      render_success
    else
      new_rating = article.ratings.create(rating_params)
      if new_rating.persisted?
        render_success
      else
        render json: { error_message: 'Can not process recieved parameters' }, status: 422
      end
    end
  end

  private

  def rating_params
    { rating: params[:rating], user_id: current_user.id }
  end

  def render_success
    render json: { message: 'You successfuly rated this article' }, status: 200
  end
end
