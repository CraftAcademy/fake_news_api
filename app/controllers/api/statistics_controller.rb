class Api::StatisticsController < ApplicationController
  def index;
  render json: StatisticsIndexSerializer
  end
end
