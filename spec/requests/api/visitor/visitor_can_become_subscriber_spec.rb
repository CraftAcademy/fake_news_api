RSpec.describe 'POST /api/auth', type: :request do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before(:each) { StripeMock.start }
  after(:each) { StripeMock.stop }
  let(:payment_method) {
    Stripe::PaymentMethod.create({
      type: 'card',
      card: {
        number: '4242424242424242',
        exp_month: 5,
        exp_year: 2022,
        cvc: '314',
      },
    })
  }

  let(:product) { stripe_helper.create_product }
  let!(:plan) do
    stripe_helper.create_plan(
      id: 'yearly_subscription',
      name: 'Fake News 12 month subscription',
      amount: 10_000,
      currency: 'sek',
      interval: 'month',
      interval_count: 12,
      product: product.id
    )
  end

  describe 'successfully' do
    before do
      post '/api/auth', params: {
        email: 'fake@email.com',
        password: 'password',
        password_confirmation: 'password',
        first_name: 'Bob',
        last_name: 'Kramer',
        plan: 'yearly_subscription',
        role: 'subscriber',
        stripe_details: payment_method
      }
    end

    it 'is expected to return status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to respond with success message' do
      expect(response_json['status']).to eq 'success'
    end

    it 'is expected to upgrade member to subscriber' do
      expect(User.find_by(email: 'fake@email.com').subscriber?).to eq true
    end
  end

  describe 'unsuccessfully with invalid payment method' do
    let(:invalid_token) { {"id" => "pm_test_wrong"} }
    before do
      post '/api/auth', params: {
        email: 'fake@email.com',
        password: 'password',
        password_confirmation: 'password',
        first_name: 'Bob',
        last_name: 'Kramer',
        plan: 'yearly_subscription',
        role: 'subscriber',
        stripeToken: invalid_token.to_json
      }
    end

    it 'is expected to respond with status 400' do
      expect(response).to have_http_status 400
    end

    it 'is expected to respond with a message' do
      expect(response_json['message']).to eq 'Unable to process payment, please try again later'
    end

    it 'is expected not to save user in the database' do
      expect(User.find_by(email: 'fake@email.com')).to eq nil
    end
  end

  describe 'unsuccesfully without stripe token' do
    before do
      post '/api/auth', params: {
        email: 'fake@email.com',
        password: 'password',
        password_confirmation: 'password',
        first_name: 'Bob',
        last_name: 'Kramer',
        plan: 'yearly_subscription',
        role: 'subscriber'
      }
    end

    it 'is expected to respond with status 400' do
      expect(response).to have_http_status 400
    end

    it 'is expected to respond with a message' do
      expect(response_json['message']).to eq 'Unable to process payment, please try again later'
    end

    it 'is expected not to save user in the database' do
      expect(User.find_by(email: 'fake@email.com')).to eq nil
    end
  end
end
