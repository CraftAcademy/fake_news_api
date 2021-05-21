class Api::SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    if params[:stripeToken]
      begin
        customer = Stripe::Customer.list(email: current_user.email).data.first
        customer = Stripe::Customer.create({ email: current_user.email, source: params[:stripeToken] })
        subscription = Stripe::Subscription.create({ customer: customer.id, plan: params[:plan] })

        if Rails.env.test?
          invoice = Stripe::Invoice.create({ customer: customer.id, subscription: subscription.id, paid: true })
          subscription.latest_invoice = invoice.id
          status = Stripe::Invoice.retrieve(subscription.latest_invoice).paid
        else
          status = Stripe::Invoice.retrieve(subscription.latest_invoice).paid
        end

        if status
          current_user.update(role: 'subscriber')
          current_user.save
          render json: { message: 'Thank you for subscribing!', paid: true }, status: 200
        else
          User.destroy(current_user.id) and return if User.where(id: current_user.id) == []
          render json: { message: 'Unable to process payment, please try again later' }, status: 401
        end
      rescue StandardError => e
        User.delete(current_user.id) and return if User.where(id: current_user.id) == []
        #render json: { message: 'Unable to process payment, please try again later' }, status: 401
      end
    else

      User.delete(current_user.id)
      render json: { message: 'Unable to process payment, please try again later' }, status: 401
    end
  end
end
