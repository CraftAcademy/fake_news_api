class Api::StatisticsController < ApplicationController
  before_action :authenticate_editor

  def index
    api_key = 'bearer sk_test_51IovvJL7WvJmM60HFPImrEIk25YfJ3ovv4YOLXN77R43J7ZmPth8fKKvi2qoneds5w50RAblSRPIlaIXo2PMFEhy00w7WvCun0'
    response = RestClient.get('https://api.stripe.com/v1/subscriptions', headers: { Authorization: api_key })

    binding.pry

    @statistics = {}
    set_statistics
    render json: { statistics: @statistics }
  end

  private

  def set_statistics
    @statistics[:articles] = {
      total: Article.where(backyard: false).count,
      published: Article.where(published: true, backyard: false).count,
      unpublished: Article.where(published: false, backyard: false).count
    }
    @statistics[:backyard_articles] = { total: Article.where(backyard: true).count }
    @statistics[:journalists] = { total: User.where(role: 5).count }
    @statistics[:subscribers] = { total: User.where(role: 2).count }
  end

  def authenticate_editor
    return if current_user.editor?

    render json: { error_message: 'You are not authorized to view this information' }, status: 403
  end
end
