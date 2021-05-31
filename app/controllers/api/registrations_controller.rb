class Api::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def create
    if current_user&.editor?
      super
    elsif params[:role] == 'journalist'
      render json: { message: 'You are not authorised to add a journalist' }, status: 401
    else
      begin
        customer = Stripe::Customer.list(email: params[:email]).data.first
        customer ||= Stripe::Customer.create({ email: params[:email] })
        payment_method = if Rails.env == 'test'
                           Stripe::PaymentMethod.attach(JSON.parse(params[:stripe_details])['id'],
                                                        { customer: customer.id })
                         else
                           Stripe::PaymentMethod.attach(params[:stripe_details][:paymentMethod][:id],
                                                        { customer: customer.id })
                         end

        Stripe::Customer.update(customer.id, { invoice_settings: { default_payment_method: payment_method } })
        subscription = Stripe::Subscription.create({ customer: customer.id, plan: params[:plan] })

        if payment_status(customer, subscription)
          super
        else

          render json: { message: 'Unable to process payment, please try again later' }, status: 400
        end
      rescue StandardError => e
        render json: { message: 'Unable to process payment, please try again later' }, status: 400
      end
    end
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
