RSpec.describe 'POST /api/subscriptions', type: :request do
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
  let!(:member) { create(:user, role: 'member', email: 'wannabe_subscriber@gmail.com') }
  let(:auth_headers) { member.create_new_auth_token }

  describe 'successfully' do
    before do
      post '/api/subscriptions', params: {
        plan: 'yearly_subscription',
        stripeToken: stripe_token
      }, headers: auth_headers
      member.reload
    end

    it 'is expected to return status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return success message' do
      expected_response = { message: 'Thank you for subscribing!', paid: true }
      expect(response_json).to eq expected_response.as_json
    end

    it 'is expected to upgrade member to subscriber' do
      expect(member.subscriber?).to eq true
    end
  end

  describe 'unsuccessfully with invalid token' do
    let(:invalid_token) { '12345678' }
    before do
      post '/api/subscriptions', params: {
        plan: 'yearly_subscription',
        stripeToken: invalid_token
      }, headers: auth_headers
      member.reload
    end

    it 'is expected to respond with status 401' do
      expect(response).to have_http_status 401
    end

    it 'is expected to respond with a message' do
      expect(response_json['message']).to eq 'Unable to process payment, please try again later'
    end

    it "is expected to remove the created user from the database" do
      expect(User.where(id: member.id)).to eq []  
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
end
