class Api::RatingsController < ApplicationController
  def create
    Rating.create({ rating: params[:rating] })
  end

  private

  def rating_params
    params.permit(:article_id, :rating)
  end
end
