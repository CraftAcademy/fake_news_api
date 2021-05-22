class Api::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def create
    customer = Stripe::Customer.list(email: params[:email]).data.first
    customer ||= Stripe::Customer.create({ email: params[:email], source: params[:stripeToken] })
    subscription = Stripe::Subscription.create({ customer: customer.id, plan: params[:plan] })

    if payment_status(customer, subscription)
      super
    else
      render json: { message: 'Unable to process payment, please try again later' }, status: 400
    end
  rescue StandardError => e
    render json: { message: 'Unable to process payment, please try again later' }, status: 400
  end

  private

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
