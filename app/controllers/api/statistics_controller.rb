class Api::StatisticsController < ApplicationController
  before_action :authenticate_editor

  def index
    @statistics = {}
    get_local_statistics
    get_articles_timeline
    begin
      headers = { Authorization: 'Bearer sk_test_51IovvJL7WvJmM60HFPImrEIk25YfJ3ovv4YOLXN77R43J7ZmPth8fKKvi2qoneds5w50RAblSRPIlaIXo2PMFEhy00w7WvCun0' }
      response = RestClient.get('https://api.stripe.com/v1/subscriptions', headers)
      data = JSON.parse(response)
      stripe_data_extractor(data)
    rescue StandardError => e
      stripe_error = JSON.parse(e.response)['error']['message']
      render json: { statistics: @statistics, stripe_error: stripe_error }, status: e.response.code and return
    end
    render json: { statistics: @statistics }
  end

  private

  def authenticate_editor
    return if current_user.editor?

    render json: { error_message: 'You are not authorized to view this information' }, status: 403
  end

  def get_local_statistics
    @statistics[:articles] = {
      total: Article.where(backyard: false).count,
      published: Article.where(published: true, backyard: false).count,
      unpublished: Article.where(published: false, backyard: false).count
    }
    @statistics[:backyard_articles] = { total: Article.where(backyard: true).count }
    @statistics[:journalists] = { total: User.where(role: 5).count }
  end

  def stripe_data_extractor(data)
    amount_of_subscribers = {
      total: 0,
      yearly_subscription: 0,
      half_year_subscription: 0,
      monthly_subscription: 0
    }

    total_income = {
      total: 0,
      yearly_subscription: 0,
      half_year_subscription: 0,
      monthly_subscription: 0
    }

    data['data'].each do |subscription|
      amount_of_subscribers[:total] += 1
      id = subscription['items']['data'].first['price']['id']
      case id
      when 'yearly_subscription'
        amount_of_subscribers[:yearly_subscription] += 1
        total_income[:yearly_subscription] = amount_of_subscribers[:yearly_subscription] * 100
      when 'half_year_subscription'
        amount_of_subscribers[:half_year_subscription] += 1
        total_income[:half_year_subscription] = amount_of_subscribers[:half_year_subscription] * 110
      when 'monthly_subscription'
        amount_of_subscribers[:monthly_subscription] += 1
        total_income[:monthly_subscription] = amount_of_subscribers[:monthly_subscription] * 130
      end
    end
    total_income.each do |_key, value|
      total_income[:total] += value
    end

    @statistics[:subscribers] = amount_of_subscribers
    @statistics[:total_income] = total_income
  end

  def get_articles_timeline
    timeline = []
    (0...7).each do |i|
      date = (DateTime.now - i).strftime('%F')
      timeline.push({ date: date, articles: 0 })

      Article.where(backyard: false).each do |article|
        timeline[i][:articles] += 1 if article[:created_at].strftime('%F') == date
      end
    end
    @statistics[:articles_timeline] = timeline
  end
end
