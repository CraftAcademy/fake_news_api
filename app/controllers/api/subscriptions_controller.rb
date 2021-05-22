class Api::SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :cannot_process_payment

  def create
    customer = Stripe::Customer.list(email: email).data.first
    customer ||= Stripe::Customer.create({ email: current_user.email, source: params[:stripeToken] })
    subscription = Stripe::Subscription.create({ customer: customer.id, plan: params[:plan] })

    if payment_status(customer, subscription) && current_user.subscriber!
      render json: { message: 'Thank you for subscribing!', paid: true }, status: 200
      # else

      #   binding.pry

      #   render json: { message: 'Unable to process payment, please try again later' }, status: 401
    end
  rescue StandardError => e
    # current_user.delete
    render json: { message: 'Unable to process payment, please try again later' }, status: 401 and return
    # binding.pry

    # user = User.find(current_user.id)
    # user.delete
    # render json: { message: 'Unable to process payment, please try again later' }, status: 401 and return
  end

  private

  def cannot_process_payment
    unless params[:stripeToken]
      current_user.delete
      render json: { message: 'Unable to process payment, please try again later' }, status: 401
    end
  end

  def payment_status(customer, subscription)
    if Rails.env.test?
      invoice = Stripe::Invoice.create({ customer: customer.id, subscription: subscription.id, paid: true })
      subscription.latest_invoice = invoice.id
      status = Stripe::Invoice.retrieve(subscription.latest_invoice).paid
    else
      status = Stripe::Invoice.retrieve(subscription.latest_invoice).paid
    end
    status
  end
end
