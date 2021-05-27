RSpec.describe 'GET api/statistics', type: :request do
  let!(:editor) { create(:user, role: 'editor') }
  let!(:editor_headers) { editor.create_new_auth_token }
  let!(:journalist) { create(:user, role: 'journalist') }
  let!(:journalist_headers) { journalist.create_new_auth_token }
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

    it 'is expected to respond with total amount income from monthly subscribers' do
      expect(response_json['statistics']['total_income']['monthly_subscription']).to eq 650
    end

    it 'is expected to respond with total amount income from all sources' do
      expect(response_json['statistics']['total_income']['total']).to eq 1170
    end
  end

  describe 'Unsuccessfully as a journalist' do
    before do
      get '/api/statistics', headers: journalist_headers
    end

    it 'is expected to return a 403 status' do
      expect(response).to have_http_status 403
    end

    it 'is expected to return an error message' do
      expect(response_json['error_message']).to eq 'You are not authorized to view this information'
    end
  end

  describe 'unsuccessfully when stripe is not responding' do
    let!(:error_body) do
      file_fixture('stripe_error_response.json').read
    end

    before do
      stub_request(:get, 'https://api.stripe.com/v1/subscriptions')
        .to_return(status: 401, body: error_body, headers: {})
      get '/api/statistics', headers: editor_headers
    end

    it 'is expected to respond with a 401 status' do
      expect(response).to have_http_status 401
    end

    it 'is expected to respond with an error' do
      expect(response_json['stripe_error']).to include('You did not provide an API key.')
    end

    it 'is expected to respond with local statistics in the event of a stripe error' do
      expect(response_json['statistics']['journalists']['total']).to eq 1
    end
  end
end
