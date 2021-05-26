RSpec.describe 'GET api/statistics', type: :request do
  let!(:editor) { create(:user, role: 'editor') }
  let!(:editor_headers) { editor.create_new_auth_token }
  let!(:subscriptions_data) do
    file_fixture('stripe_stats.json').read
  end

  describe 'Successfully as an editor be able to see company financial statistics' do
    before do
      stub_request(:get, 'https://api.stripe.com/v1/subscriptions')
        .to_return(status: 200, body: subscriptions_data, headers: {})
      get '/api/statistics', headers: editor_headers
    end

    it 'is expected to respond with a status code 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to respond with total amount of subscribers' do
      expect(response_json['statistics']['subscribers']['total']).to eq 10
    end

    # it 'is expected to respond with total amount of subscribers' do
    #   expect(response_json['statistics']['subscribers']['total']).to eq 10
    # end
  end
end
