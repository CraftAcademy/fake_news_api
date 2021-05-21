RSpec.describe 'POST /api/subscriptions', type: :request do
  let(:stripe_helper) {StripeMock.create_test_helper}
  before(:each) { StripeMock.start }
  after(:each) { StripeMock.stop }
  let(:stripe_token) { stripe_helper.generate_card_token }
  let(:product) { stripe_helper.create_product }
  let!(:plan) do
    stripe_helper.create_plan(
      id: 'yearly_subscription',
      name: 'Fake News 12 month subscription',
      amount: 10000,
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
end
