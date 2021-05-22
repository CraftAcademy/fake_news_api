RSpec.describe 'POST /api/auth', type: :request do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before(:each) { StripeMock.start }
  after(:each) { StripeMock.stop }
  let(:stripe_token) { stripe_helper.generate_card_token }
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
        stripeToken: stripe_token
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

  describe 'unsuccessfully with invalid token' do
    let(:invalid_token) { '12345678' }
    before do
      post '/api/subscriptions', params: {
        plan: 'yearly_subscription',
        stripeToken: invalid_token
      }, headers: auth_headers
      # member.reload
    end

    it 'is expected to respond with status 401' do
      expect(response).to have_http_status 401
    end

    it 'is expected to respond with a message' do
      expect(response_json['message']).to eq 'Unable to process payment, please try again later'
    end

    it 'is expected to remove the created user from the database' do
      expect { User.find(member.id) }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe 'unsuccesfully without authentication' do
    before do
      post '/api/subscriptions', params: {
        plan: 'yearly_subscription',
        stripeToken: stripe_token
      }
      member.reload
    end

    it 'is expected to respond with status 401' do
      expect(response).to have_http_status 401
    end

    it 'is expected to respond with a message' do
      expect(response_json['errors'].first).to eq 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'unsuccesfully without stripe token' do
    before do
      post '/api/subscriptions', params: {
        plan: 'yearly_subscription'
      }, headers: auth_headers
    end

    it 'is expected to respond with status 401' do
      expect(response).to have_http_status 401
    end

    it 'is expected to respond with a message' do
      expect(response_json['message']).to eq 'Unable to process payment, please try again later'
    end

    it 'is expected to remove the created user from the database' do
      expect { User.find(member.id) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
